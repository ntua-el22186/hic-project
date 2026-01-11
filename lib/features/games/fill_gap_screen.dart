import 'package:flutter/material.dart';
import 'widgets/game_layout.dart';

class FillGapScreen extends StatelessWidget {
  const FillGapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      title: "Fill the Gap",
      prompt: "Complete the sentence:",
      questionContent: const Text(
        "The _______ rabbit ran across the field.",
        style: TextStyle(fontSize: 22, fontFamily: 'Serif'),
      ),
      answerArea: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your answer:", style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: "Type the word...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8EFFF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8EFFF)),
              ),
            ),
          ),
        ],
      ),
      onSubmit: () {},
    );
  }
}