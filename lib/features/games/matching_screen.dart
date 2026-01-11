import 'package:flutter/material.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      appBar: AppBar(title: const Text("Matching", style: TextStyle(fontFamily: 'Serif')), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Type the Matching Number on the Keyboard (1, 2 or 3) for the words in the order below",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF1A41CC), fontSize: 13),
            ),
            const SizedBox(height: 20),
            
            // Words List
            _sectionHeader("WORDS"),
            _matchItem("Happy"),
            _matchItem("Quick"),
            _matchItem("Strong"),
            
            const Divider(height: 40),

            // Definitions List
            _sectionHeader("DEFINITIONS"),
            _matchItem("1. Having the power to move heavy things."),
            _matchItem("2. Feeling or showing pleasure."),
            _matchItem("3. Moving fast or doing something quickly."),

            const Spacer(),
            
            // Action Buttons
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF90A4E4),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Submit Answer", style: TextStyle(color: Colors.white)),
            ),
            TextButton(onPressed: () {}, child: const Text("Reset", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
      ),
    );
  }

  Widget _matchItem(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EFFF)),
      ),
      child: Text(text),
    );
  }
}