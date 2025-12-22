import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyNumberMerge = 'highscore_number_merge';
  static const String keyWordGuess = 'highscore_word_guess';
  static const String keyPictureMatch = 'highscore_picture_match';

  Future<void> saveHighScore(String gameKey, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHigh = prefs.getInt(gameKey) ?? 0;
    if (score > currentHigh) {
      await prefs.setInt(gameKey, score);
    }
  }

  Future<int> getHighScore(String gameKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(gameKey) ?? 0;
  }
}
