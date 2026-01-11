import 'package:flutter/material.dart';
import '../../core/models/word_model.dart';

class WordDetailScreen extends StatelessWidget {
  const WordDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This line grabs the Word data passed from the list page
    final wordItem = ModalRoute.of(context)!.settings.arguments as WordModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details", style: TextStyle(fontFamily: 'Serif')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Blue Word Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1A41CC),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(wordItem.word, style: const TextStyle(color: Colors.white, fontSize: 36, fontFamily: 'Serif', fontWeight: FontWeight.bold)),
                      Text(wordItem.phonetic, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.volume_up, color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Definition Section
            _buildSectionCard("DEFINITION", Text(wordItem.definition)),
            const SizedBox(height: 16),

            // 3. Examples Section
            _buildSectionCard(
              "EXAMPLES",
              Column(
                children: wordItem.examples.map((ex) => _buildExampleTile(ex)).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Personal Notes Section
            _buildSectionCard(
              "MY NOTES",
              const Text("Add notes here...", style: TextStyle(color: Colors.orange)),
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
    return Container(
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