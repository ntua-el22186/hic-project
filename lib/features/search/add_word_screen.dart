import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../core/services/word_service.dart';
import '../../core/models/word_model.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _defController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final WordService _wordService = WordService();
  bool _isLoading = false;
  String _currentPhonetic = "";

  Future<void> _lookupWord() async {
    if (_wordController.text.isEmpty) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final definitionData = await _wordService.fetchDefinition(_wordController.text);

    if (definitionData != null) {
      String definition = definitionData['meanings'][0]['definitions'][0]['definition'];
      String? phonetic = definitionData['phonetic'];

      setState(() {
        _defController.text = definition;
        _currentPhonetic = phonetic ?? "";
        _isLoading = false;
      });

      HapticFeedback.lightImpact();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Word not found!")),
      );
    }
  }

  void _saveWord() {
    final String word = _wordController.text.trim();
    final String definition = _defController.text.trim();
    final String example = _exampleController.text.trim();

    if (word.isEmpty || definition.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill at least the word and definition")),
      );
      return;
    }

    // Έλεγχος αν η λέξη περιέχεται στο παράδειγμα για το Fill the Gap
    if (example.isNotEmpty && !example.toLowerCase().contains(word.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange.shade900,
          content: Text("The word '$word' must be in the example for the games to work!"),
        ),
      );
      return;
    }

    final box = Hive.box<WordModel>('words_box');

    final newEntry = WordModel(
      word: word,
      phonetic: _currentPhonetic,
      definition: definition,
      examples: [example],
      personalNote: _notesController.text,
    );

    box.add(newEntry);
    HapticFeedback.heavyImpact();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Το GestureDetector εδώ επιτρέπει το κλείσιμο του πληκτρολογίου με ένα tap στην οθόνη
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New Word", style: TextStyle(fontFamily: 'Serif')),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enter Word", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _wordController,
                      decoration: InputDecoration(
                        hintText: "Type a word...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _lookupWord,
                    icon: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.search, size: 18),
                    label: Text(_isLoading ? "..." : "Lookup"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90A4E4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              if (_currentPhonetic.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_currentPhonetic, style: const TextStyle(color: Color(0xFF1A41CC), fontStyle: FontStyle.italic)),
                ),
              const SizedBox(height: 32),
              _buildLabelAndField("Definition", "Definition automatically fetched...", maxLines: 3, controller: _defController),
              const SizedBox(height: 16),
              // ΕΔΩ ΕΙΝΑΙ ΤΟ ΠΕΔΙΟ ΓΙΑ ΤΟ ΠΑΡΑΔΕΙΓΜΑ
              _buildLabelAndField(
                "Example (Personal)", 
                "Type the sentence where you found the word...", 
                maxLines: 3, 
                controller: _exampleController,
                textInputAction: TextInputAction.done, // Κλείνει το πληκτρολόγιο
              ),
              const SizedBox(height: 16),
              _buildLabelAndField("Personal Notes", "Add notes here ...", maxLines: 3, controller: _notesController),
            ],
          ),
        ),
        bottomNavigationBar: _buildSaveButton(),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: _saveWord,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A41CC),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Save Word", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLabelAndField(String label, String hint, {int maxLines = 1, TextEditingController? controller, TextInputAction? textInputAction}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          textInputAction: textInputAction, // Ορίζει τη δράση του πληκτρολογίου
          onSubmitted: (_) => FocusScope.of(context).unfocus(), // Κλείνει το πληκτρολόγιο στο "Done"
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}