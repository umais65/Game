import 'dart:math';
import 'package:game_app/utils/words.dart';

enum LetterStatus { correct, present, absent, unknown }
enum GameStatus { playing, won, lost }

class WordGuessLogic {
  String targetWord = '';
  List<String> guesses = [];
  String currentGuess = '';
  GameStatus status = GameStatus.playing;
  final int maxGuesses = 6;

  void startNewGame() {
    targetWord = gameWords[Random().nextInt(gameWords.length)];
    guesses = [];
    currentGuess = '';
    status = GameStatus.playing;
    // print('Target Word: $targetWord'); // For debugging
  }

  void addLetter(String letter) {
    if (status != GameStatus.playing) return;
    if (currentGuess.length < 5) {
      currentGuess += letter.toUpperCase();
    }
  }

  void removeLetter() {
    if (status != GameStatus.playing) return;
    if (currentGuess.isNotEmpty) {
      currentGuess = currentGuess.substring(0, currentGuess.length - 1);
    }
  }

  bool submitGuess() {
    if (status != GameStatus.playing) return false;
    if (currentGuess.length != 5) return false;

    guesses.add(currentGuess);

    if (currentGuess == targetWord) {
      status = GameStatus.won;
    } else if (guesses.length >= maxGuesses) {
      status = GameStatus.lost;
    }

    currentGuess = '';
    return true;
  }

  LetterStatus getLetterStatus(String letter, int index, String guess) {
    if (!targetWord.contains(letter)) return LetterStatus.absent;
    if (targetWord[index] == letter) return LetterStatus.correct;
    return LetterStatus.present;
  }
  
  // Helper to get keyboard key status
  LetterStatus getKeyStatus(String key) {
    LetterStatus finalStatus = LetterStatus.unknown;
    
    for (var guess in guesses) {
      for (int i = 0; i < 5; i++) {
        if (guess[i] == key) {
          var status = getLetterStatus(key, i, guess);
          if (status == LetterStatus.correct) return LetterStatus.correct;
          if (status == LetterStatus.present && finalStatus != LetterStatus.correct) {
            finalStatus = LetterStatus.present;
          }
          if (status == LetterStatus.absent && finalStatus == LetterStatus.unknown) {
            finalStatus = LetterStatus.absent;
          }
        }
      }
    }
    return finalStatus;
  }
}
