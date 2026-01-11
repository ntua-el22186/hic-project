import 'package:flutter/material.dart';
import 'widgets/game_layout.dart';

class DictationScreen extends StatelessWidget {
  const DictationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      title: "Dictation",
      prompt: "Press to listen to the word",
      questionContent: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.volume_up, color: Colors.white, size: 32),
        ),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
      onSubmit: () {},
    );
  }
}