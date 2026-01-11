import 'package:flutter/material.dart';
import '../../core/models/word_model.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Dictionary", style: TextStyle(fontFamily: 'Serif')),
        actions: [const Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.lightbulb_outline, color: Colors.orange))],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Bar inside the list page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Word",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(alignment: Alignment.centerLeft, child: Text("4 words found", style: TextStyle(color: Colors.grey))),
          ),

          // 2. The Scrollable List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockDictionary.length,
              itemBuilder: (context, index) {
                final item = mockDictionary[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/word-detail', arguments: item),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE8EFFF)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}