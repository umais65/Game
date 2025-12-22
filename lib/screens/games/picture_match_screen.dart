import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_app/models/picture_match_logic.dart';
import 'package:game_app/services/storage_service.dart';

class PictureMatchScreen extends StatefulWidget {
  const PictureMatchScreen({super.key});

  @override
  State<PictureMatchScreen> createState() => _PictureMatchScreenState();
}

class _PictureMatchScreenState extends State<PictureMatchScreen> {
  final PictureMatchLogic _game = PictureMatchLogic();
  final StorageService _storage = StorageService();
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _game.reset();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final score = await _storage.getHighScore(StorageService.keyPictureMatch);
    setState(() {
      _highScore = score;
    });
  }

  Future<void> _updateHighScore() async {
    if (_game.score > _highScore) {
      setState(() {
        _highScore = _game.score;
      });
      await _storage.saveHighScore(StorageService.keyPictureMatch, _highScore);
    }
  }

  void _onCardTap(int index) {
    setState(() {
      bool? result = _game.flipCard(index);
      if (result == false) {
        // Mismatch, wait and flip back
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              // Find the two flipped, non-matched cards
              List<int> flipped = [];
              for (int i = 0; i < _game.cards.length; i++) {
                if (_game.cards[i].isFlipped && !_game.cards[i].isMatched) {
                  flipped.add(i);
                }
              }
              if (flipped.length == 2) {
                _game.flipBack(flipped[0], flipped[1]);
              }
            });
          }
        });
      } else if (result == true) {
        // Match
        if (_game.isGameOver()) {
          _updateHighScore();
          _showGameOverDialog();
        }
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('You Won!'),
        content: Text('Score: ${_game.score}\nMoves: ${_game.moves}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _game.reset();
              });
            },
            child: const Text('Play Again'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Match'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _game.reset();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreCard('Score', _game.score),
                _buildScoreCard('Best', _highScore),
                _buildScoreCard('Moves', _game.moves),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _game.cards.length,
                itemBuilder: (context, index) {
                  final card = _game.cards[index];
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedContainer(
                      duration: 300.ms,
                      decoration: BoxDecoration(
                        color: card.isFlipped || card.isMatched
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: card.isFlipped || card.isMatched
                          ? Icon(
                              card.icon,
                              size: 32,
                              color: Colors.white,
                            ).animate().scale()
                          : const Icon(
                              Icons.question_mark,
                              color: Colors.grey,
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          '$score',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
