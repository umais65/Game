import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_app/models/word_guess_logic.dart';
import 'package:game_app/services/storage_service.dart';

class WordGuessScreen extends StatefulWidget {
  const WordGuessScreen({super.key});

  @override
  State<WordGuessScreen> createState() => _WordGuessScreenState();
}

class _WordGuessScreenState extends State<WordGuessScreen> {
  final WordGuessLogic _game = WordGuessLogic();
  final StorageService _storage = StorageService();
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _game.startNewGame();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final score = await _storage.getHighScore(StorageService.keyWordGuess);
    setState(() {
      _highScore = score;
    });
  }

  Future<void> _handleWin() async {
    // Score calculation: 7 - number of guesses used (max 6)
    // 1 guess = 6 points, 6 guesses = 1 point
    int score = 7 - _game.guesses.length;
    // Accumulate score? Or just max score for a single game?
    // The prompt says "Store the highest score". For Wordle usually it's a streak or total wins.
    // Let's make it "Total Wins" or just "Best Run".
    // Actually, let's just add to a cumulative score for this session or something.
    // To keep it simple and consistent with "High Score", let's say High Score = Max Wins in a row?
    // Or just simple: Score = Total Correct Guesses stored?
    // Let's go with: Score = Total Accumulated Points.
    
    int newTotal = _highScore + score;
    await _storage.saveHighScore(StorageService.keyWordGuess, newTotal);
    setState(() {
      _highScore = newTotal;
    });
    
    _showEndDialog('You Won!', 'The word was ${_game.targetWord}\nPoints: +$score');
  }

  void _showEndDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _game.startNewGame();
              });
            },
            child: const Text('Next Word'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _onKeyPressed(String key) {
    setState(() {
      if (key == 'ENTER') {
        if (_game.submitGuess()) {
          if (_game.status == GameStatus.won) {
            _handleWin();
          } else if (_game.status == GameStatus.lost) {
            _showEndDialog('Game Over', 'The word was ${_game.targetWord}');
          }
        }
      } else if (key == 'DEL') {
        _game.removeLetter();
      } else {
        _game.addLetter(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Guess'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $_highScore',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AspectRatio(
                aspectRatio: 5 / 6,
                child: Column(
                  children: List.generate(6, (i) => Expanded(child: _buildRow(i))),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildKeyboard(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(int rowIndex) {
    String word = '';
    if (rowIndex < _game.guesses.length) {
      word = _game.guesses[rowIndex];
    } else if (rowIndex == _game.guesses.length) {
      word = _game.currentGuess.padRight(5);
    } else {
      word = '     ';
    }

    return Row(
      children: List.generate(5, (i) {
        String letter = word[i];
        Color color = Colors.transparent;
        Color borderColor = Colors.grey;
        
        if (rowIndex < _game.guesses.length) {
          LetterStatus status = _game.getLetterStatus(letter, i, word);
          switch (status) {
            case LetterStatus.correct:
              color = Colors.green;
              borderColor = Colors.green;
              break;
            case LetterStatus.present:
              color = Colors.orange;
              borderColor = Colors.orange;
              break;
            case LetterStatus.absent:
              color = Colors.grey[800]!;
              borderColor = Colors.grey[800]!;
              break;
            default:
              break;
          }
        } else if (letter.trim().isNotEmpty) {
          borderColor = Colors.white;
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).animate(target: rowIndex < _game.guesses.length ? 1 : 0).flipH(duration: 400.ms, delay: (i * 100).ms),
        );
      }),
    );
  }

  Widget _buildKeyboard() {
    final rows = [
      'QWERTYUIOP',
      'ASDFGHJKL',
      'ZXCVBNM'
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...rows.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.split('').map((char) {
              return _buildKey(char);
            }).toList(),
          );
        }),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton('DEL', Colors.red.withValues(alpha: 0.3)),
            const SizedBox(width: 8),
            _buildActionButton('ENTER', Colors.green.withValues(alpha: 0.3)),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String char) {
    LetterStatus status = _game.getKeyStatus(char);
    Color color = Colors.grey[800]!;
    if (status == LetterStatus.correct) {
      color = Colors.green;
    } else if (status == LetterStatus.present) {
      color = Colors.orange;
    } else if (status == LetterStatus.absent) {
      color = Colors.black;
    }
    return GestureDetector(
      onTap: () => _onKeyPressed(char),
      child: Container(
        width: 32,
        height: 40,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          char,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return GestureDetector(
      onTap: () => _onKeyPressed(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
