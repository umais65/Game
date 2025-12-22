import 'package:flutter/material.dart';

class CardItem {
  final int id;
  final IconData icon;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.id,
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class PictureMatchLogic {
  List<CardItem> cards = [];
  int moves = 0;
  int score = 1000;
  bool isProcessing = false;

  final List<IconData> _icons = [
    Icons.star,
    Icons.favorite,
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.beach_access,
    Icons.cake,
    Icons.camera,
    Icons.directions_car,
  ];

  void reset() {
    moves = 0;
    score = 1000;
    isProcessing = false;
    
    List<IconData> gameIcons = [..._icons, ..._icons];
    gameIcons.shuffle();
    
    cards = List.generate(16, (index) => CardItem(
      id: index,
      icon: gameIcons[index],
    ));
  }

  // Returns true if match found, false if not match (need to flip back), null if just first card
  bool? flipCard(int index) {
    if (isProcessing || cards[index].isFlipped || cards[index].isMatched) return null;

    cards[index].isFlipped = true;

    // Check if another card is flipped but not matched
    int? firstIndex;
    for (int i = 0; i < cards.length; i++) {
      if (i != index && cards[i].isFlipped && !cards[i].isMatched) {
        firstIndex = i;
        break;
      }
    }

    if (firstIndex != null) {
      moves++;
      score = (score - 10).clamp(0, 1000);
      
      if (cards[firstIndex].icon == cards[index].icon) {
        cards[firstIndex].isMatched = true;
        cards[index].isMatched = true;
        return true;
      } else {
        isProcessing = true;
        return false;
      }
    }
    
    return null;
  }

  void flipBack(int index1, int index2) {
    cards[index1].isFlipped = false;
    cards[index2].isFlipped = false;
    isProcessing = false;
  }

  bool isGameOver() {
    return cards.every((card) => card.isMatched);
  }
}
