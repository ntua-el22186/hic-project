import 'dart:convert';
import 'package:http/http.dart' as http;

class WordService {
  // 1. Φέρνει ορισμό και παραδείγματα από το Free Dictionary API
  Future<Map<String, dynamic>?> fetchDefinition(String word) async {
    final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data[0]; // Επιστρέφει το πρώτο αποτέλεσμα
      }
    } catch (e) {
      print("Error fetching dictionary: $e");
    }
    return null;
  }

  // 2. Φέρνει "Related Words" (αυτό που ζήτησες) από το Datamuse API
  Future<List<String>> fetchRelatedWords(String word) async {
    // rel_trg = related trigger (φέρνει λέξεις που σχετίζονται εννοιολογικά)
    final url = Uri.parse('https://api.datamuse.com/words?rel_trg=$word&max=5');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => item['word'].toString()).toList();
      }
    } catch (e) {
      print("Error fetching related words: $e");
    }
    return [];
  }
}
