class WordModel {
  final String word;
  final String phonetic;
  final String definition;
  final List<String> examples;
  final String? personalNote;

  WordModel({
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.examples,
    this.personalNote,
  });
}

// Mock Data to test your UI immediately
List<WordModel> mockDictionary = [
  WordModel(
    word: "Happy",
    phonetic: "/ˈhæpi/",
    definition: "Feeling or showing pleasure or contentment.",
    examples: ["She was happy to see her friends.", "The children played happily in the park."],
  ),
  WordModel(
    word: "Quick",
    phonetic: "/kwɪk/",
    definition: "Moving fast or doing something in a short time.",
    examples: ["He took a quick look at the map."],
  ),
];