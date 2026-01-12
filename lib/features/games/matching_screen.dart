import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/word_model.dart';
import 'widgets/game_layout.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final Box<WordModel> _wordBox = Hive.box<WordModel>('words_box');
  
  List<WordModel> _quizWords = [];
  List<String> _shuffledDefinitions = [];
  String? _selectedWord;
  String? _selectedDefinition;
  
  // Προσωρινά matches πριν το submit
  Map<String, String> _pendingMatches = {};
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    if (_wordBox.length < 3) return;
    var allWords = _wordBox.values.toList()..shuffle();
    _quizWords = allWords.take(3).toList();
    _shuffledDefinitions = _quizWords.map((w) => w.definition).toList()..shuffle();
    
    setState(() {
      _pendingMatches.clear();
      _selectedWord = null;
      _selectedDefinition = null;
      _hasSubmitted = false;
    });
  }

  void _handleTap() {
    if (_hasSubmitted) return;

    if (_selectedWord != null && _selectedDefinition != null) {
      setState(() {
        // Αποθηκεύουμε το ζευγάρι προσωρινά (χωρίς να ξέρουμε ακόμα αν είναι σωστό)
        _pendingMatches[_selectedWord!] = _selectedDefinition!;
        _selectedWord = null;
        _selectedDefinition = null;
      });
    }
  }

  void _handleSubmit() {
    if (_hasSubmitted) {
      _setupGame(); // Αν έχει ήδη γίνει submit, πάμε στον επόμενο γύρο
      return;
    }

    setState(() {
      _hasSubmitted = true;
      // Ελέγχουμε ένα-ένα τα matches και ενημερώνουμε τη βάση
      for (var wordObj in _quizWords) {
        String? userDef = _pendingMatches[wordObj.word];
        if (userDef == wordObj.definition) {
          wordObj.correctAnswers++;
        } else {
          wordObj.wrongAnswers++;
        }
        wordObj.save();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_wordBox.length < 3) return const Scaffold(body: Center(child: Text("Add 3 words!")));

    // Το κουμπί είναι ενεργό αν έχουν γίνει 3 ταιριάσματα ή αν έχει γίνει ήδη submit
    bool canSubmit = _pendingMatches.length == 3 || _hasSubmitted;

    return GameLayout(
      title: "Matching",
      buttonLabel: _hasSubmitted ? "Next Round" : (_pendingMatches.length < 3 ? "Match everything" : "Submit Matches"),
      onSubmit: canSubmit ? _handleSubmit : null,
      prompt: _hasSubmitted ? "Results are in!" : "Match the words with their definitions:",
      questionContent: Center(
        child: Column(
          children: [
            Icon(
              _hasSubmitted ? Icons.analytics : Icons.extension, 
              size: 40, 
              color: const Color(0xFF1A41CC)
            ),
            const SizedBox(height: 8),
            Text(
              _hasSubmitted ? "Review your matches" : "${_pendingMatches.length}/3 Matched",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            )
          ],
        ),
      ),
      answerArea: SingleChildScrollView(
        child: Column(
          children: [
            _sectionHeader("WORDS"),
            ..._quizWords.map((w) => _buildItem(
              w.word, 
              isSelected: _selectedWord == w.word,
              isMatched: _pendingMatches.containsKey(w.word),
              wordObj: w,
              isWord: true,
              onTap: () { 
                if (_pendingMatches.containsKey(w.word)) {
                  setState(() => _pendingMatches.remove(w.word)); // Unmatch αν το ξαναπατήσει
                } else {
                  setState(() => _selectedWord = w.word); _handleTap(); 
                }
              }
            )),
            const SizedBox(height: 20),
            _sectionHeader("DEFINITIONS"),
            ..._shuffledDefinitions.map((def) => _buildItem(
              def,
              isSelected: _selectedDefinition == def,
              isMatched: _pendingMatches.containsValue(def),
              wordObj: _quizWords.firstWhere((w) => w.definition == def),
              isWord: false,
              onTap: () { 
                if (_pendingMatches.containsValue(def)) {
                  setState(() => _pendingMatches.removeWhere((key, value) => value == def));
                } else {
                  setState(() => _selectedDefinition = def); _handleTap(); 
                }
              }
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String text, {
    required bool isSelected, 
    required bool isMatched, 
    required WordModel wordObj,
    required bool isWord,
    required VoidCallback onTap
  }) {
    Color borderColor = const Color(0xFFE0E0E0);
    Color bgColor = Colors.white;

    if (_hasSubmitted) {
      // Μετά το Submit: Πράσινο αν το βρήκε, Κόκκινο αν έκανε λάθος
      String? userChoice = isWord ? _pendingMatches[text] : _pendingMatches.keys.firstWhere((k) => _pendingMatches[k] == text, orElse: () => "");
      bool wasCorrect = isWord ? userChoice == wordObj.definition : userChoice == wordObj.word;

      if (isMatched && wasCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
      } else if (isMatched && !wasCorrect) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
      }
    } else if (isMatched) {
      // Πριν το Submit: Απλό μπλε για να φαίνεται ότι επιλέχθηκε
      borderColor = const Color(0xFF1A41CC);
      bgColor = const Color(0xFFE8EFFF);
    } else if (isSelected) {
      borderColor = Colors.orange;
      bgColor = Colors.orange.shade50;
    }

    return GestureDetector(
      onTap: _hasSubmitted ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
    );
  }
}