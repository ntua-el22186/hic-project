import 'package:flutter/material.dart';
import 'widgets/game_layout.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      title: "Quiz Game",
      prompt: "What is the Definition of:",
      questionContent: const Text(
        "Strong",
        style: TextStyle(fontSize: 32, fontFamily: 'Serif', fontWeight: FontWeight.bold),
      ),
      answerArea: Column(
        children: [
          _quizOption("Having the power to move heavy things or do hard tasks."),
          _quizOption("Feeling or showing pleasure or contentment."),
          _quizOption("Moving fast or doing something in a short time."),
          _quizOption("Giving out or reflecting a lot of light."),
        ],
      ),
      onSubmit: () {},
    );
  }

  Widget _quizOption(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EFFF)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}