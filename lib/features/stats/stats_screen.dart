import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text("Statistics", style: TextStyle(fontFamily: 'Serif')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. Top Grid (2x2)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildStatCard("Total Words", "4", Icons.menu_book, isPrimary: true),
                _buildStatCard("Day Streak", "0", Icons.calendar_today),
                _buildStatCard("Overall Statistics", "76%", Icons.trending_up),
                _buildStatCard("Best Game", "Fill Gap", Icons.auto_awesome),
              ],
            ),
            const SizedBox(height: 32),

            // 2. Bar Chart Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Game Performance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar("Quiz", 80, const Color(0xFF3B82F6)),
                    _buildBar("Matching", 70, const Color(0xFF1A41CC)),
                    _buildBar("Dictation", 65, const Color(0xFF3B82F6)),
                    _buildBar("Fill Gap", 90, const Color(0xFF1A41CC)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {},
              child: const Text("Log off", style: TextStyle(color: Colors.red, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF1A41CC) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isPrimary ? null : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPrimary ? Colors.white.withOpacity(0.2) : const Color(0xFFE8EFFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: isPrimary ? Colors.white : const Color(0xFF1A41CC), size: 20),
          ),
          const Spacer(),
          Text(label, style: TextStyle(color: isPrimary ? Colors.white70 : Colors.black54, fontSize: 12)),
          Text(value, style: TextStyle(color: isPrimary ? Colors.white : Colors.black, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightPercent, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: heightPercent * 1.5,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}