import 'package:flutter/material.dart';

class GameLayout extends StatelessWidget {
  final String title;
  final String prompt;
  final Widget questionContent;
  final Widget answerArea;
  final VoidCallback? onSubmit;
  final String? hint;
  final String buttonLabel;

  const GameLayout({
    super.key,
    required this.title,
    required this.prompt,
    required this.questionContent,
    required this.answerArea,
    required this.onSubmit,
    this.hint,
    this.buttonLabel = "Submit Answer",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Η κρίσιμη ρύθμιση: Το UI δεν μικραίνει όταν βγαίνει το πληκτρολόγιο
      resizeToAvoidBottomInset: false, 
      backgroundColor: const Color(0xFFF0F6FF),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          children: [
            // Κάρτα Ερώτησης
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 10)],
                border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prompt, style: const TextStyle(color: Color(0xFF1A41CC), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  questionContent,
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            if (hint != null) _buildHintBox(hint!),
            
            const SizedBox(height: 20),

            // Περιοχή Απαντήσεων
            Expanded(child: answerArea),

            // Σταθερό Κουμπί στο κάτω μέρος
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A41CC),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Text("Hint: $text", style: const TextStyle(color: Colors.black87, fontSize: 14, fontStyle: FontStyle.italic)),
    );
  }
}