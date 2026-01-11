import 'package:flutter/material.dart';

class GameLayout extends StatelessWidget {
  final String title;
  final String prompt;
  final Widget questionContent;
  final Widget answerArea;
  final VoidCallback onSubmit;

  const GameLayout({
    super.key,
    required this.title,
    required this.prompt,
    required this.questionContent,
    required this.answerArea,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF), // Light blue background from your screenshot
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Serif')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prompt, style: const TextStyle(color: Color(0xFF1A41CC), fontSize: 14)),
                  const SizedBox(height: 12),
                  questionContent,
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Hint Section (Dynamic for each game)
            _buildHintBox(),
            const SizedBox(height: 24),

            // Answer Area
            Expanded(child: answerArea),

            // Action Buttons
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF90A4E4),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Submit Answer", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text("Reset", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hint - Definition:", style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8EFFF)),
          ),
          child: const Text("Press Down for the Hint to Appear", style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}