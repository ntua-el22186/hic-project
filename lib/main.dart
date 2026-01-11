import 'package:flutter/material.dart';

// Import all your features
import 'package:my_app/features/home/home_screen.dart';
import 'package:my_app/features/dictionary/dictionary_screen.dart';
import 'package:my_app/features/dictionary/word_detail_screen.dart';
import 'package:my_app/features/search/add_word_screen.dart';
import 'package:my_app/features/stats/stats_screen.dart';
import 'package:my_app/features/games/dictation_screen.dart';
import 'package:my_app/features/games/matching_screen.dart'; // We will create this next
import 'package:my_app/features/games/quiz_screen.dart';
import 'package:my_app/features/games/fill_gap_screen.dart';

void main() => runApp(const DictionaryApp());

class DictionaryApp extends StatelessWidget {
  const DictionaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary Learner',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFF),
        primaryColor: const Color(0xFF1A41CC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A41CC)),
        // Setup for the Serif look in your Figma titles
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontFamily: 'Serif', color: Color(0xFF1A41CC), fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'Serif', fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/dictionary': (context) => const DictionaryScreen(),
        '/word-detail': (context) => const WordDetailScreen(),
        '/add-word': (context) => const AddWordScreen(),
        '/stats': (context) => const StatsScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/fill-gap': (context) => const FillGapScreen(),
        '/matching': (context) => const MatchingScreen(),
        '/dictation': (context) => const DictationScreen(),
      },
    );
  }
}