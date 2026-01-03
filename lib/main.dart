import 'package:flutter/material.dart';
import 'package:game_app/config/theme.dart';
import 'package:game_app/screens/home_screen.dart';
import 'package:game_app/screens/games/number_merge_screen.dart';
import 'package:game_app/screens/games/word_guess_screen.dart';
import 'package:game_app/screens/games/picture_match_screen.dart';
import 'package:game_app/screens/splash_screen.dart';
import 'package:game_app/screens/login_screen.dart';
import 'package:game_app/screens/signup_screen.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Games',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/': (context) => const HomeScreen(),
        '/number_merge': (context) => const NumberMergeScreen(),
        '/word_guess': (context) => const WordGuessScreen(),
        '/picture_match': (context) => const PictureMatchScreen(),
      },
    );
  }
}
