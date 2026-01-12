import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/word_model.dart';
import 'widgets/game_layout.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Box<WordModel> _wordBox = Hive.box<WordModel>('words_box');
  late WordModel _currentWord;
  List<String> _options = [];
  bool _hasSubmitted = false; // Έχει πατήσει το κουμπί ελέγχου;
  String _selectedAnswer = ""; // Τι επέλεξε πριν το submit

  @override
  void initState() {
    super.initState();
    _loadNextSmartQuestion();
  }

  void _loadNextSmartQuestion() {
    if (_wordBox.length < 4) return;

    var allWords = _wordBox.values.toList();
    allWords.sort((a, b) => (b.wrongAnswers - b.correctAnswers).compareTo(a.wrongAnswers - a.correctAnswers));

    final range = allWords.length > 5 ? 5 : allWords.length;
    _currentWord = allWords[Random().nextInt(range)];

    List<String> allDefs = _wordBox.values.map((e) => e.definition).toList();
    allDefs.remove(_currentWord.definition);
    allDefs.shuffle();

    setState(() {
      _options = [_currentWord.definition, ...allDefs.take(3)];
      _options.shuffle();
      _hasSubmitted = false;
      _selectedAnswer = "";
    });
  }

  // 1. Επιλογή απάντησης (χωρίς να δείχνει ακόμα σωστό/λάθος)
  void _onOptionTap(String selected) {
    if (_hasSubmitted) return; // Κλείδωμα μετά το submit
    setState(() {
      _selectedAnswer = selected;
    });
  }

  // 2. Η κύρια λειτουργία του κουμπιού
  void _handleMainAction() {
    // Φάση Α: Πατάει Submit χωρίς να έχει επιλέξει τίποτα (Skip = Λάθος)
    if (!_hasSubmitted && _selectedAnswer.isEmpty) {
      setState(() {
        _currentWord.wrongAnswers++;
        _currentWord.save();
        _hasSubmitted = true; // Δείχνουμε τη σωστή απάντηση πριν φύγουμε
      });
      return;
    }

    // Φάση Β: Πατάει Submit έχοντας επιλέξει κάτι
    if (!_hasSubmitted) {
      setState(() {
        _hasSubmitted = true;
        if (_selectedAnswer == _currentWord.definition) {
          _currentWord.correctAnswers++;
        } else {
          _currentWord.wrongAnswers++;
        }
        _currentWord.save();
      });
      return;
    }

    // Φάση Γ: Έχει ήδη γίνει το submit, οπότε το κουμπί πλέον πάει στην επόμενη λέξη
    _loadNextSmartQuestion();
  }

  @override
  Widget build(BuildContext context) {
    if (_wordBox.length < 4) return const Scaffold(body: Center(child: Text("Πρόσθεσε 4 λέξεις!")));

    return GameLayout(
      title: "Quiz",
      prompt: "What is the definition of:",
      questionContent: Center(
        child: Text(
          _currentWord.word,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A41CC)),
        ),
      ),
      answerArea: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _options.length,
        itemBuilder: (context, index) {
          final def = _options[index];
          return _buildOptionCard(def);
        },
      ),
      // Το κουμπί είναι πάντα ενεργό
      onSubmit: _handleMainAction,
      // Το κείμενο αλλάζει δυναμικά
      buttonLabel: _hasSubmitted 
          ? "Next Word" 
          : (_selectedAnswer.isEmpty ? "Skip / I don't know" : "Submit Answer"),
    );
  }

  Widget _buildOptionCard(String definition) {
    bool isCorrect = definition == _currentWord.definition;
    bool isSelected = definition == _selectedAnswer;

    Color borderColor = const Color(0xFFE8EFFF);
    Color bgColor = Colors.white;

    // Λογική Χρωμάτων
    if (_hasSubmitted) {
      // Μετά το Submit δείχνουμε την αλήθεια
      if (isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
      } else if (isSelected) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
      }
    } else {
      // Πριν το Submit δείχνουμε μόνο τι έχει επιλεγεί (π.χ. με μπλε)
      if (isSelected) {
        borderColor = const Color(0xFF1A41CC);
        bgColor = const Color(0xFFF0F6FF);
      }
    }

    return GestureDetector(
      onTap: () => _onOptionTap(definition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(definition, style: const TextStyle(fontSize: 15))),
            if (_hasSubmitted && isCorrect) const Icon(Icons.check_circle, color: Colors.green),
            if (_hasSubmitted && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }
}