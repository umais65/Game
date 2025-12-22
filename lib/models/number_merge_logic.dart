import 'dart:math';

class NumberMergeLogic {
  int score = 0;
  List<List<int>> grid = List.generate(4, (_) => List.filled(4, 0));
  final Random _random = Random();

  void reset() {
    score = 0;
    grid = List.generate(4, (_) => List.filled(4, 0));
    addNewTile();
    addNewTile();
  }

  void addNewTile() {
    List<Point<int>> emptyCells = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == 0) {
          emptyCells.add(Point(i, j));
        }
      }
    }
    if (emptyCells.isNotEmpty) {
      final point = emptyCells[_random.nextInt(emptyCells.length)];
      grid[point.x][point.y] = _random.nextInt(10) == 0 ? 4 : 2;
    }
  }

  bool moveLeft() {
    bool changed = false;
    for (int i = 0; i < 4; i++) {
      List<int> newRow = [];
      // Filter non-zeros
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] != 0) newRow.add(grid[i][j]);
      }
      
      // Merge
      for (int j = 0; j < newRow.length - 1; j++) {
        if (newRow[j] == newRow[j + 1]) {
          newRow[j] *= 2;
          score += newRow[j];
          newRow.removeAt(j + 1);
        }
      }

      // Pad with zeros
      while (newRow.length < 4) {
        newRow.add(0);
      }

      // Check if changed
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] != newRow[j]) {
          changed = true;
          grid[i][j] = newRow[j];
        }
      }
    }
    return changed;
  }

  bool moveRight() {
    // Reverse, move left, reverse back
    for (int i = 0; i < 4; i++) {
      grid[i] = grid[i].reversed.toList();
    }
    bool changed = moveLeft();
    for (int i = 0; i < 4; i++) {
      grid[i] = grid[i].reversed.toList();
    }
    return changed;
  }

  bool moveUp() {
    bool changed = false;
    for (int j = 0; j < 4; j++) {
      List<int> newCol = [];
      for (int i = 0; i < 4; i++) {
        if (grid[i][j] != 0) newCol.add(grid[i][j]);
      }

      for (int i = 0; i < newCol.length - 1; i++) {
        if (newCol[i] == newCol[i + 1]) {
          newCol[i] *= 2;
          score += newCol[i];
          newCol.removeAt(i + 1);
        }
      }

      while (newCol.length < 4) {
        newCol.add(0);
      }

      for (int i = 0; i < 4; i++) {
        if (grid[i][j] != newCol[i]) {
          changed = true;
          grid[i][j] = newCol[i];
        }
      }
    }
    return changed;
  }

  bool moveDown() {
    bool changed = false;
    for (int j = 0; j < 4; j++) {
      List<int> newCol = [];
      for (int i = 3; i >= 0; i--) {
        if (grid[i][j] != 0) newCol.add(grid[i][j]);
      }

      for (int i = 0; i < newCol.length - 1; i++) {
        if (newCol[i] == newCol[i + 1]) {
          newCol[i] *= 2;
          score += newCol[i];
          newCol.removeAt(i + 1);
        }
      }

      while (newCol.length < 4) {
        newCol.add(0);
      }

      for (int i = 0; i < 4; i++) {
        if (grid[3 - i][j] != newCol[i]) {
          changed = true;
          grid[3 - i][j] = newCol[i];
        }
      }
    }
    return changed;
  }

  bool isGameOver() {
    // Check for empty cells
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == 0) return false;
      }
    }
    // Check for possible merges
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (i < 3 && grid[i][j] == grid[i + 1][j]) return false;
        if (j < 3 && grid[i][j] == grid[i][j + 1]) return false;
      }
    }
    return true;
  }
}
