import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/models/word_model.dart'; // Βεβαιώσου ότι η διαδρομή είναι σωστή

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ανοίγουμε το box για να το παρακολουθούμε
    final wordBox = Hive.box<WordModel>('words_box');

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: wordBox.listenable(), // Ακούει για κάθε αλλαγή (προσθήκη/διαγραφή)
          builder: (context, Box<WordModel> box, _) {
            final int wordCount = box.length;
            final bool isLocked = wordCount < 4; // Λογική κλειδώματος

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi, there",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(fontSize: 28)),
                          const Text("Ready to learn today?",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      // STATS BUTTON
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/stats'),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE8EFFF),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.bar_chart, color: Color(0xFF1A41CC)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Search Bar (Add New Word)
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/add-word'),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Add New Word",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. My Dictionary Card
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/dictionary'),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A41CC),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("My Dictionary",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'Serif')),
                                // ΔΥΝΑΜΙΚΟ ΚΕΙΜΕΝΟ
                                Text("$wordCount words saved",
                                    style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)),
                            child: const Icon(Icons.menu_book, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 4. Game Hub Header
                  Center(
                    child: Column(
                      children: [
                        const Text("GAME HUB",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        // Μήνυμα αν είναι κλειδωμένα
                        if (isLocked)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("Add ${4 - wordCount} more words to unlock",
                                style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          )
                        else
                          const Text("Choose a game to practice your words",
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GAME GRID
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildGameCard(context, Icons.psychology, "Quiz", '/quiz', isLocked),
                      _buildGameCard(context, Icons.edit, "Fill Gap", '/fill-gap', isLocked),
                      _buildGameCard(context, Icons.link, "Matching", '/matching', isLocked),
                      _buildGameCard(context, Icons.mic, "Dictation", '/dictation', isLocked),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Αναβαθμισμένο helper method για το κλείδωμα
  Widget _buildGameCard(BuildContext context, IconData icon, String title, String route, bool isLocked) {
    return GestureDetector(
      onTap: isLocked 
        ? () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unlock by adding at least 4 words!")))
        : () => Navigator.pushNamed(context, route),
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isLocked ? Colors.grey.shade200 : const Color(0xFFE8EFFF)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: isLocked ? Colors.grey : const Color(0xFF1A41CC)),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: isLocked ? Colors.grey : Colors.black
              )),
              if (isLocked) const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}