import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_app/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  Map<String, int> _highScores = {};

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    final nm = await _storage.getHighScore(StorageService.keyNumberMerge);
    final wg = await _storage.getHighScore(StorageService.keyWordGuess);
    final pm = await _storage.getHighScore(StorageService.keyPictureMatch);
    setState(() {
      _highScores = {
        StorageService.keyNumberMerge: nm,
        StorageService.keyWordGuess: wg,
        StorageService.keyPictureMatch: pm,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Games'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Choose a Game',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),
          const SizedBox(height: 24),
          _buildGameCard(
            context,
            'Number Merge',
            '2048 Style Puzzle',
            Icons.grid_4x4,
            Colors.purpleAccent,
            '/number_merge',
            _highScores[StorageService.keyNumberMerge] ?? 0,
          ).animate().fadeIn(delay: 200.ms).slideX(),
          const SizedBox(height: 16),
          _buildGameCard(
            context,
            'Word Guess',
            'Guess the 5-letter word',
            Icons.abc,
            Colors.greenAccent,
            '/word_guess',
            _highScores[StorageService.keyWordGuess] ?? 0,
          ).animate().fadeIn(delay: 400.ms).slideX(),
          const SizedBox(height: 16),
          _buildGameCard(
            context,
            'Picture Match',
            'Test your memory',
            Icons.image,
            Colors.orangeAccent,
            '/picture_match',
            _highScores[StorageService.keyPictureMatch] ?? 0,
          ).animate().fadeIn(delay: 600.ms).slideX(),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String route,
    int highScore,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, route);
          _loadHighScores(); // Refresh scores on return
        },
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.2), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'High Score',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    highScore.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
