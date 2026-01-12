import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/models/word_model.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // Η νέα διαβάθμιση Badges που ζήτησες
  String _getBadge(int totalWords) {
    if (totalWords < 25) return "🥚 Apprentice";
    if (totalWords < 50) return "🎯 Striker";
    if (totalWords < 100) return "🥉 Bronze";
    if (totalWords < 250) return "🥈 Silver";
    if (totalWords < 500) return "🥇 Gold";
    return "💎 Platinum";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<WordModel>('words_box').listenable(),
      builder: (context, Box<WordModel> box, _) {
        final allWords = box.values.toList();
        final totalWords = allWords.length;

        final totalCorrect = allWords.fold(0, (sum, w) => sum + w.correctAnswers);
        final totalWrong = allWords.fold(0, (sum, w) => sum + w.wrongAnswers);
        final mastered = allWords.where((w) => w.correctAnswers >= 5).length;
        
        double accuracy = (totalCorrect + totalWrong) == 0 
            ? 0 
            : (totalCorrect / (totalCorrect + totalWrong)) * 100;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          appBar: AppBar(title: const Text("Performance Stats"), elevation: 0),
          body: totalWords == 0 
            ? const Center(child: Text("Πρόσθεσε λέξεις για να δεις στατιστικά!"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainScoreCard(_getBadge(totalWords), totalWords, accuracy),
                    const SizedBox(height: 32),
                    
                    const Text("SKILLS BREAKDOWN", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 16),

                    _buildSkillTile("Vocabulary (Quiz)", accuracy > 70 ? "Advanced" : "Intermediate", Colors.blue, accuracy / 100),
                    _buildSkillTile("Spelling (Dictation)", totalWords > 10 ? "Consistent" : "Getting Started", Colors.purple, 0.4),
                    _buildSkillTile("Memory (Matching)", mastered > 5 ? "Strong" : "Developing", Colors.orange, mastered / (totalWords == 0 ? 1 : totalWords)),
                    _buildSkillTile("Context (Fill the Gap)", totalCorrect > 20 ? "Master" : "Learning", Colors.green, (totalCorrect % 10) / 10),

                    const SizedBox(height: 32),
                    const Text("ACTIVITY SUMMARY", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 16),
                    _buildActivityRow(totalCorrect, totalWrong),
                  ],
                ),
              ),
        );
      },
    );
  }

  Widget _buildMainScoreCard(String badge, int total, double accuracy) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A41CC), Color(0xFF4361EE)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _scoreItem("Rank", badge),
          Container(width: 1, height: 40, color: Colors.white24),
          _scoreItem("Words", total.toString()),
          Container(width: 1, height: 40, color: Colors.white24),
          _scoreItem("Accuracy", "${accuracy.toStringAsFixed(0)}%"),
        ],
      ),
    );
  }

  Widget _scoreItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildSkillTile(String title, String level, Color color, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(level, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress.clamp(0.0, 1.0), backgroundColor: color.withOpacity(0.1), color: color, minHeight: 8, borderRadius: BorderRadius.circular(10)),
        ],
      ),
    );
  }

  Widget _buildActivityRow(int correct, int wrong) {
    return Row(
      children: [
        Expanded(child: _activityBox("Correct", correct.toString(), Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _activityBox("Mistakes", wrong.toString(), Colors.red)),
      ],
    );
  }

  Widget _activityBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.1))),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}