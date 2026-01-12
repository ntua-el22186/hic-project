import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends HiveObject {
  @HiveField(0)
  final String word;

  @HiveField(1)
  final String phonetic;

  @HiveField(2)
  final String definition;

  @HiveField(3)
  final List<String> examples;

  @HiveField(4)
  String? personalNote;

  @HiveField(5)
  int correctAnswers;

  @HiveField(6)
  int wrongAnswers;

  @HiveField(7)
  DateTime? lastPracticed;

  WordModel({
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.examples,
    this.personalNote,
    this.correctAnswers = 0, // Default τιμή
    this.wrongAnswers = 0,   // Default τιμή
    this.lastPracticed,
  });

  // Factory μέθοδος για τη δημιουργία από το API
  factory WordModel.fromApi(Map<String, dynamic> json) {
    // Παίρνουμε το πρώτο meaning και το πρώτο definition
    final meaning = json['meanings'][0];
    final def = meaning['definitions'][0];

    return WordModel(
      word: json['word'] ?? '',
      phonetic: json['phonetic'] ?? '',
      definition: def['definition'] ?? '',
      // Αν υπάρχει παράδειγμα το βάζουμε σε λίστα, αλλιώς κενή λίστα
      examples: def['example'] != null ? [def['example']] : [],
      correctAnswers: 0,
      wrongAnswers: 0,
      lastPracticed: DateTime.now(),
    );
  }
}