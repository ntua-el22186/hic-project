import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/word_model.dart';
import 'widgets/game_layout.dart';

class FillGapScreen extends StatefulWidget {
  const FillGapScreen({super.key});

  @override
  State<FillGapScreen> createState() => _FillGapScreenState();
}

class _FillGapScreenState extends State<FillGapScreen> {
  final Box<WordModel> _wordBox = Hive.box<WordModel>('words_box');
  final TextEditingController _controller = TextEditingController();
  
  late WordModel _currentWord;
  late String _sentenceWithGap;
  bool _isCorrect = false;
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    _generateLevel();
  }

  void _generateLevel() {
    if (_wordBox.isEmpty) return;

    var wordsWithExamples = _wordBox.values.where((w) => w.examples.isNotEmpty).toList();
    
    if (wordsWithExamples.isEmpty) {
      _currentWord = _wordBox.values.first;
      _sentenceWithGap = "Missing word: _______";
    } else {
      wordsWithExamples.shuffle();
      _currentWord = wordsWithExamples.first;
      
      String rawSentence = _currentWord.examples.first;
      _sentenceWithGap = rawSentence.replaceAll(
        RegExp(_currentWord.word, caseSensitive: false), 
        "_______"
      );
    }

    setState(() {
      _controller.clear();
      _hasChecked = false;
      _isCorrect = false;
    });
  }

  void _handleAction() {
    if (_hasChecked) {
      _generateLevel();
      return;
    }

    FocusScope.of(context).unfocus(); // Κλείνει το πληκτρολόγιο
    
    String userAnswer = _controller.text.trim().toLowerCase();
    String correctAnswer = _currentWord.word.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      if (userAnswer.isEmpty) {
        _isCorrect = false;
        _currentWord.wrongAnswers++;
      } else if (userAnswer == correctAnswer) {
        _isCorrect = true;
        _currentWord.correctAnswers++;
      } else {
        _isCorrect = false;
        _currentWord.wrongAnswers++;
      }
      _currentWord.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_wordBox.isEmpty) return const Scaffold(body: Center(child: Text("Add words!")));

    return GameLayout(
      title: "Fill the Gap",
      prompt: "Complete the sentence:",
      buttonLabel: _hasChecked 
          ? "Next Sentence" 
          : (_controller.text.isEmpty ? "Skip / Show Answer" : "Check Answer"),
      onSubmit: _handleAction,
      hint: _currentWord.definition,
      questionContent: Center(
        child: Text(
          _sentenceWithGap,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, height: 1.5, color: Color(0xFF1A41CC), fontWeight: FontWeight.w500),
        ),
      ),
      answerArea: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              autocorrect: false,
              enabled: !_hasChecked, 
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Type here...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.edit, color: Color(0xFF1A41CC)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
              // Το πλήκτρο 'Done' στο πληκτρολόγιο απλά το κλείνει
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 24),
            if (_hasChecked)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _isCorrect ? Colors.green : Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(_isCorrect ? Icons.check_circle : Icons.error, color: _isCorrect ? Colors.green : Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isCorrect ? "Correct! Well done." : "The word was: ${_currentWord.word}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: _isCorrect ? Colors.green : Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}