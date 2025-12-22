import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_app/models/number_merge_logic.dart';
import 'package:game_app/services/storage_service.dart';

class NumberMergeScreen extends StatefulWidget {
  const NumberMergeScreen({super.key});

  @override
  State<NumberMergeScreen> createState() => _NumberMergeScreenState();
}

class _NumberMergeScreenState extends State<NumberMergeScreen> {
  final NumberMergeLogic _game = NumberMergeLogic();
  final StorageService _storage = StorageService();
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _game.reset();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final score = await _storage.getHighScore(StorageService.keyNumberMerge);
    setState(() {
      _highScore = score;
    });
  }

  Future<void> _updateHighScore() async {
    if (_game.score > _highScore) {
      setState(() {
        _highScore = _game.score;
      });
      await _storage.saveHighScore(StorageService.keyNumberMerge, _highScore);
    }
  }

  void _handleMove(Function moveFn) {
    setState(() {
      if (moveFn()) {
        _game.addNewTile();
        _updateHighScore();
        if (_game.isGameOver()) {
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
        title: const Text('Game Over'),
        content: Text('Your Score: ${_game.score}'),
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

  Color _getTileColor(int value) {
    switch (value) {
      case 2: return Colors.cyan.withValues(alpha: 0.5);
      case 4: return Colors.cyan;
      case 8: return Colors.blue;
      case 16: return Colors.indigo;
      case 32: return Colors.purple;
      case 64: return Colors.pink;
      case 128: return Colors.red;
      case 256: return Colors.orange;
      case 512: return Colors.amber;
      case 1024: return Colors.yellow;
      case 2048: return Colors.green;
      default: return Colors.grey.withValues(alpha: 0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Merge'),
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
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _handleMove(_game.moveLeft);
                  } else if (details.primaryVelocity! > 0) {
                    _handleMove(_game.moveRight);
                  }
                },
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _handleMove(_game.moveUp);
                  } else if (details.primaryVelocity! > 0) {
                    _handleMove(_game.moveDown);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        int x = index ~/ 4;
                        int y = index % 4;
                        int value = _game.grid[x][y];
                        return AnimatedContainer(
                          duration: 200.ms,
                          decoration: BoxDecoration(
                            color: value == 0
                                ? Colors.white.withValues(alpha: 0.05)
                                : _getTileColor(value),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: value == 0
                              ? null
                              : Text(
                                  '$value',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ).animate().scale(duration: 200.ms),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 32.0),
            child: Text(
              'Swipe to move tiles',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
