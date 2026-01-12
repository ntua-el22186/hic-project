import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // 1. Import το TTS
import '../../core/models/word_model.dart';

class WordDetailScreen extends StatefulWidget {
  const WordDetailScreen({super.key});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  // 2. Δημιουργία του αντικειμένου TTS
  final FlutterTts flutterTts = FlutterTts();

  // 3. Συνάρτηση για την ομιλία
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US"); // Ρύθμιση στα Αγγλικά
    await flutterTts.setPitch(1.0);        // Τόνος φωνής
    await flutterTts.speak(text);          // Εκκίνηση ομιλίας
  }

  void _deleteWord(WordModel item) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Word?"),
        content: Text("Are you sure you want to remove '${item.word}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await item.delete();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordItem = ModalRoute.of(context)!.settings.arguments as WordModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details", style: TextStyle(fontFamily: 'Serif')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _deleteWord(wordItem),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1A41CC),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          wordItem.word, 
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontFamily: 'Serif', fontWeight: FontWeight.bold)
                        ),
                      ),
                      // 4. Σύνδεση του κουμπιού με τη συνάρτηση _speak
                      GestureDetector(
                        onTap: () => _speak(wordItem.word),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.volume_up, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  if (wordItem.phonetic.isNotEmpty)
                    Text(wordItem.phonetic, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionCard("DEFINITION", Text(wordItem.definition)),
            const SizedBox(height: 16),

            if (wordItem.examples.isNotEmpty && wordItem.examples.first.isNotEmpty)
              _buildSectionCard(
                "EXAMPLES",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: wordItem.examples.map((ex) => _buildExampleTile(ex)).toList(),
                ),
              ),
            const SizedBox(height: 16),

            _buildSectionCard(
              "MY NOTES",
              Text(
                (wordItem.personalNote == null || wordItem.personalNote!.isEmpty) 
                    ? "No notes added yet." 
                    : wordItem.personalNote!,
                style: TextStyle(color: (wordItem.personalNote == null) ? Colors.grey : Colors.black87),
              ),
              borderColor: Colors.orange.shade200,
              icon: Icons.edit_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content, {Color? borderColor, IconData? icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? const Color(0xFFE8EFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 1.1)),
              if (icon != null) Icon(icon, size: 18, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildExampleTile(String text) {
    if (text.isEmpty) return const SizedBox();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFFF).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFF1A41CC), width: 4)),
      ),
      child: Text('"$text"', style: const TextStyle(fontStyle: FontStyle.italic)),
    );
  }
}