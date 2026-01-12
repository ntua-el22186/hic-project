import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import Models
import 'core/models/word_model.dart';

// Import Screens
import 'package:dicapp/features/auth/login_screen.dart';
import 'package:dicapp/features/auth/signup_screen.dart';
import 'package:dicapp/features/home/home_screen.dart';
import 'package:dicapp/features/dictionary/dictionary_screen.dart';
import 'package:dicapp/features/dictionary/word_detail_screen.dart';
import 'package:dicapp/features/search/add_word_screen.dart';
import 'package:dicapp/features/stats/stats_screen.dart';
import 'package:dicapp/features/games/dictation_screen.dart';
import 'package:dicapp/features/games/matching_screen.dart';
import 'package:dicapp/features/games/quiz_screen.dart';
import 'package:dicapp/features/games/fill_gap_screen.dart';

void main() async {
  // 1. Βεβαιωνόμαστε ότι τα Flutter bindings είναι έτοιμα (απαραίτητο για το async)
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Αρχικοποίηση Hive για Flutter
  await Hive.initFlutter();
  
  // 3. Καταχώρηση του WordModelAdapter (αυτό που έφτιαξε το build_runner)
  Hive.registerAdapter(WordModelAdapter());
  
  // 4. Άνοιγμα του Box "words_box" - Εδώ θα μένουν μόνιμα οι λέξεις
  await Hive.openBox<WordModel>('words_box');

  // 5. Εκκίνηση της εφαρμογής
  runApp(const DictionaryApp());
}

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
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontFamily: 'Serif', color: Color(0xFF1A41CC), fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'Serif', fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home' : (context) => const HomeScreen(),
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