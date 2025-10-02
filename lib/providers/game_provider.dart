import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../models/game_state.dart';
import '../models/ai_component.dart';

class GameProvider extends ChangeNotifier {
  static const int gridSize = 4;
  late GameState _gameState;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

  GameProvider() {
    _initializeGame();
    _loadHighScore();
  }

  GameState get gameState => _gameState;

  void _initializeGame() {
    final grid = List.generate(gridSize, (_) => List<int?>.filled(gridSize, null));
    _gameState = GameState(
      grid: grid,
      score: 0,
      moves: 0,
      gameOver: false,
      highScore: 0,
    );
    _addRandomComponent();
    _addRandomComponent();
  }

  void _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final highScore = prefs.getInt('high_score') ?? 0;
    _gameState = _gameState.copyWith(highScore: highScore);
    notifyListeners();
  }

  void _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('high_score', _gameState.highScore);
  }

  void _addRandomComponent() {
    final emptyCells = <List<int>>[];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (_gameState.grid[i][j] == null) {
          emptyCells.add([i, j]);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final randomCell = emptyCells[_random.nextInt(emptyCells.length)];
      final level = _random.nextDouble() < 0.9 ? 1 : 2; // 90% chance for level 1, 10% for level 2
      _gameState.grid[randomCell[0]][randomCell[1]] = level;
    }
  }

  bool canMove() {
    // Check for empty cells
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (_gameState.grid[i][j] == null) return true;
      }
    }

    // Check for possible merges
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        final current = _gameState.grid[i][j];
        if (current == null) continue;

        // Check right
        if (j < gridSize - 1 && _gameState.grid[i][j + 1] == current) return true;
        // Check down
        if (i < gridSize - 1 && _gameState.grid[i + 1][j] == current) return true;
      }
    }

    return false;
  }

  void moveLeft() {
    if (_gameState.gameOver) return;

    bool moved = false;
    int scoreGained = 0;

    for (int i = 0; i < gridSize; i++) {
      final row = _gameState.grid[i].where((cell) => cell != null).toList();
      final mergedRow = <int?>[];
      int j = 0;

      while (j < row.length) {
        if (j < row.length - 1 && row[j] == row[j + 1]) {
          // Merge components
          final newLevel = row[j]! + 1;
          mergedRow.add(newLevel <= AIComponent.components.length ? newLevel : row[j]);
          final component = AIComponent.getComponentByLevel(newLevel);
          scoreGained += component?.points ?? 0;
          j += 2;
          moved = true;
        } else {
          mergedRow.add(row[j]);
          j++;
        }
      }

      // Fill the rest with nulls
      while (mergedRow.length < gridSize) {
        mergedRow.add(null);
      }

      // Check if row changed
      for (int k = 0; k < gridSize; k++) {
        if (_gameState.grid[i][k] != mergedRow[k]) {
          moved = true;
        }
        _gameState.grid[i][k] = mergedRow[k];
      }
    }

    if (moved) {
      _makeMove(scoreGained);
    }
  }

  void moveRight() {
    if (_gameState.gameOver) return;

    bool moved = false;
    int scoreGained = 0;

    for (int i = 0; i < gridSize; i++) {
      final row = _gameState.grid[i].where((cell) => cell != null).toList().reversed.toList();
      final mergedRow = <int?>[];
      int j = 0;

      while (j < row.length) {
        if (j < row.length - 1 && row[j] == row[j + 1]) {
          final newLevel = row[j]! + 1;
          mergedRow.add(newLevel <= AIComponent.components.length ? newLevel : row[j]);
          final component = AIComponent.getComponentByLevel(newLevel);
          scoreGained += component?.points ?? 0;
          j += 2;
          moved = true;
        } else {
          mergedRow.add(row[j]);
          j++;
        }
      }

      while (mergedRow.length < gridSize) {
        mergedRow.add(null);
      }

      final finalRow = mergedRow.reversed.toList();
      
      for (int k = 0; k < gridSize; k++) {
        if (_gameState.grid[i][k] != finalRow[k]) {
          moved = true;
        }
        _gameState.grid[i][k] = finalRow[k];
      }
    }

    if (moved) {
      _makeMove(scoreGained);
    }
  }

  void moveUp() {
    if (_gameState.gameOver) return;

    bool moved = false;
    int scoreGained = 0;

    for (int j = 0; j < gridSize; j++) {
      final column = <int?>[];
      for (int i = 0; i < gridSize; i++) {
        if (_gameState.grid[i][j] != null) {
          column.add(_gameState.grid[i][j]);
        }
      }

      final mergedColumn = <int?>[];
      int i = 0;

      while (i < column.length) {
        if (i < column.length - 1 && column[i] == column[i + 1]) {
          final newLevel = column[i]! + 1;
          mergedColumn.add(newLevel <= AIComponent.components.length ? newLevel : column[i]);
          final component = AIComponent.getComponentByLevel(newLevel);
          scoreGained += component?.points ?? 0;
          i += 2;
          moved = true;
        } else {
          mergedColumn.add(column[i]);
          i++;
        }
      }

      while (mergedColumn.length < gridSize) {
        mergedColumn.add(null);
      }

      for (int k = 0; k < gridSize; k++) {
        if (_gameState.grid[k][j] != mergedColumn[k]) {
          moved = true;
        }
        _gameState.grid[k][j] = mergedColumn[k];
      }
    }

    if (moved) {
      _makeMove(scoreGained);
    }
  }

  void moveDown() {
    if (_gameState.gameOver) return;

    bool moved = false;
    int scoreGained = 0;

    for (int j = 0; j < gridSize; j++) {
      final column = <int?>[];
      for (int i = gridSize - 1; i >= 0; i--) {
        if (_gameState.grid[i][j] != null) {
          column.add(_gameState.grid[i][j]);
        }
      }

      final mergedColumn = <int?>[];
      int i = 0;

      while (i < column.length) {
        if (i < column.length - 1 && column[i] == column[i + 1]) {
          final newLevel = column[i]! + 1;
          mergedColumn.add(newLevel <= AIComponent.components.length ? newLevel : column[i]);
          final component = AIComponent.getComponentByLevel(newLevel);
          scoreGained += component?.points ?? 0;
          i += 2;
          moved = true;
        } else {
          mergedColumn.add(column[i]);
          i++;
        }
      }

      while (mergedColumn.length < gridSize) {
        mergedColumn.add(null);
      }

      final finalColumn = mergedColumn.reversed.toList();

      for (int k = 0; k < gridSize; k++) {
        if (_gameState.grid[k][j] != finalColumn[k]) {
          moved = true;
        }
        _gameState.grid[k][j] = finalColumn[k];
      }
    }

    if (moved) {
      _makeMove(scoreGained);
    }
  }

  void _makeMove(int scoreGained) {
    final newScore = _gameState.score + scoreGained;
    final newHighScore = newScore > _gameState.highScore ? newScore : _gameState.highScore;
    
    _gameState = _gameState.copyWith(
      score: newScore,
      moves: _gameState.moves + 1,
      highScore: newHighScore,
    );

    if (newScore > _gameState.highScore) {
      _saveHighScore();
    }

    _addRandomComponent();

    if (!canMove()) {
      _gameState = _gameState.copyWith(gameOver: true);
    }

    if (scoreGained > 0) {
      _playMergeSound();
      _vibrate();
    }

    notifyListeners();
  }

  void _playMergeSound() {
    // Play merge sound effect
    try {
      _audioPlayer.play(AssetSource('sounds/merge.mp3'));
    } catch (e) {
      // Handle sound error silently
    }
  }

  void _vibrate() {
    try {
      Vibration.vibrate(duration: 50);
    } catch (e) {
      // Handle vibration error silently
    }
  }

  void resetGame() {
    _initializeGame();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}