import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/word_model.dart';
import 'widgets/game_layout.dart';

class DictationScreen extends StatefulWidget {
  const DictationScreen({super.key});

  @override
  State<DictationScreen> createState() => _DictationScreenState();
}

class _DictationScreenState extends State<DictationScreen> {
  final Box<WordModel> _wordBox = Hive.box<WordModel>('words_box');
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _controller = TextEditingController();
  
  late WordModel _currentWord;
  bool _hasChecked = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadSmartWord();
  }

  void _loadSmartWord() {
    if (_wordBox.isEmpty) return;
    
    // Επιλογή λέξης με βάση τη δυσκολία (λάθη)
    var allWords = _wordBox.values.toList();
    allWords.sort((a, b) => (b.wrongAnswers - b.correctAnswers).compareTo(a.wrongAnswers - a.correctAnswers));
    
    final range = allWords.length > 5 ? 5 : allWords.length;
    _currentWord = allWords[DateTime.now().millisecond % range];

    setState(() {
      _controller.clear();
      _hasChecked = false;
      _isCorrect = false;
    });
    
    _playVoice();
  }

  Future<void> _playVoice() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(_currentWord.word);
  }

  void _handleAction() {
    // Φάση 2: Επόμενη λέξη
    if (_hasChecked) {
      _loadSmartWord();
      return;
    }

    // Φάση 1: Έλεγχος (ή Skip αν είναι άδειο)
    FocusScope.of(context).unfocus(); // Κλείνει το πληκτρολόγιο
    
    String userInp = _controller.text.trim().toLowerCase();
    String target = _currentWord.word.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      if (userInp.isEmpty) {
        _isCorrect = false;
        _currentWord.wrongAnswers++;
      } else if (userInp == target) {
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
    if (_wordBox.isEmpty) return const Scaffold(body: Center(child: Text("Add words first!")));

    return GameLayout(
      title: "Dictation",
      prompt: "Listen carefully and type the word:",
      // Δυναμικό κείμενο κουμπιού
      buttonLabel: _hasChecked 
          ? "Next Word" 
          : (_controller.text.isEmpty ? "Skip / Show Answer" : "Check Spelling"),
      onSubmit: _handleAction,
      hint: _currentWord.definition,
      questionContent: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: _playVoice,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A41CC),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A41CC).withOpacity(0.3), 
                      blurRadius: 15, 
                      spreadRadius: 2
                    )
                  ],
                ),
                child: const Icon(Icons.volume_up, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Tap to play audio", 
              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)
            ),
          ],
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
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              decoration: InputDecoration(
                hintText: "Enter the word...",
                hintStyle: const TextStyle(fontSize: 16, letterSpacing: 0),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), 
                  borderSide: BorderSide.none
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
              // Το 'Done' απλά κλείνει το πληκτρολόγιο
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 24),
            if (_hasChecked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _isCorrect ? Colors.green : Colors.red, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isCorrect ? Icons.stars : Icons.help_outline, 
                      color: _isCorrect ? Colors.green : Colors.red
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isCorrect ? "Perfect Spelling! ✨" : "It is spelled: ${_currentWord.word}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect ? Colors.green : Colors.red,
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