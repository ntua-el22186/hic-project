import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/models/word_model.dart';
import '../../core/services/word_service.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final WordService _wordService = WordService();
  final Box<WordModel> _wordBox = Hive.box<WordModel>('words_box');
  String _searchQuery = "";

  // 1. Λειτουργία Αυτόματης Προσθήκης από Suggestion
  Future<void> _quickAddWord(String word) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final data = await _wordService.fetchDefinition(word);
    
    if (!mounted) return;
    Navigator.pop(context); // Κλείσιμο loading

    if (data != null) {
      final newWord = WordModel.fromApi(data);
      await _wordBox.add(newWord);

      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✨ '$word' added to dictionary!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not fetch details for this word.")),
      );
    }
  }

  // 2. Το Pop-up της Λάμπας
  void _showSuggestions() async {
    String seedWord = _wordBox.isNotEmpty ? _wordBox.values.last.word : "vocabulary";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final suggestions = await _wordService.fetchRelatedWords(seedWord);
    
    if (!mounted) return;
    Navigator.pop(context); // Κλείσιμο loading

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("Smart Suggestions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
            const SizedBox(height: 8),
            Text("Because you learned '$seedWord'", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            if (suggestions.isEmpty)
              const Text("No suggestions found for this word.")
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: suggestions.map((word) => ActionChip(
                  label: Text(word),
                  avatar: const Icon(Icons.add, size: 16),
                  onPressed: () {
                    Navigator.pop(context);
                    _quickAddWord(word);
                  },
                )).toList(),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Dictionary", style: TextStyle(fontFamily: 'Serif')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.orange),
            onPressed: _showSuggestions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search Word",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Real-time List from Hive
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _wordBox.listenable(),
              builder: (context, Box<WordModel> box, _) {
                final words = box.values
                    .where((w) => w.word.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList()
                    .reversed.toList();

                if (words.isEmpty) {
                  return const Center(child: Text("Your dictionary is empty."));
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft, 
                        child: Text("${words.length} words found", style: const TextStyle(color: Colors.grey))
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          final item = words[index];
                          return _buildWordCard(item);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(WordModel item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/word-detail', arguments: item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8EFFF)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (item.phonetic.isNotEmpty)
                    Text(item.phonetic, style: const TextStyle(color: Color(0xFF1A41CC))),
                  const SizedBox(height: 4),
                  Text(item.definition, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}