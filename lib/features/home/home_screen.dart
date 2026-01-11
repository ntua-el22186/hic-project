import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      Text("Hi, Maria",
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
                child: TextField(
                  enabled: false, // Tapping takes them to the Add Word page
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("My Dictionary",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Serif')),
                            Text("3 words saved",
                                style: TextStyle(color: Colors.white70)),
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
              const Center(
                child: Column(
                  children: [
                    Text("GAME HUB",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    Text("Choose a game to practice your words",
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
                  _buildGameCard(context, Icons.psychology, "Quiz", '/quiz'),
                  _buildGameCard(context, Icons.edit, "Fill Gap", '/fill-gap'),
                  _buildGameCard(context, Icons.link, "Matching", '/matching'),
                  _buildGameCard(context, Icons.mic, "Dictation", '/dictation'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated helper method to handle navigation
  Widget _buildGameCard(BuildContext context, IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8EFFF)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF1A41CC)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}