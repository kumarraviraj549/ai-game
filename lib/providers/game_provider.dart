import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/game_state.dart';
import '../models/ai_component.dart';

class GameProvider extends ChangeNotifier {
  static const int gridSize = 4;
  late GameState _gameState;
  final Random _random = Random();
  int _extraMoves = 0;

  GameProvider() {
    _initializeGame();
    _loadHighScore();
  }

  GameState get gameState => _gameState;
  int get extraMoves => _extraMoves;

  void _initializeGame() {
    final grid = List.generate(gridSize, (_) => List<int?>.filled(gridSize, null));
    _gameState = GameState(
      grid: grid,
      score: 0,
      moves: 0,
      gameOver: false,
      highScore: 0,
    );
    _extraMoves = 0;
    _addRandomComponent();
    _addRandomComponent();
  }

  void _loadHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final highScore = prefs.getInt('high_score') ?? 0;
      _gameState = _gameState.copyWith(highScore: highScore);
      notifyListeners();
    } catch (e) {
      print('Error loading high score: $e');
    }
  }

  void _saveHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('high_score', _gameState.highScore);
    } catch (e) {
      print('Error saving high score: $e');
    }
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
      final level = _random.nextDouble() < 0.9 ? 1 : 2;
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
    _performMove(_processRowsLeft);
  }

  void moveRight() {
    if (_gameState.gameOver) return;
    _performMove(_processRowsRight);
  }

  void moveUp() {
    if (_gameState.gameOver) return;
    _performMove(_processColumnsUp);
  }

  void moveDown() {
    if (_gameState.gameOver) return;
    _performMove(_processColumnsDown);
  }

  void _performMove(Function moveFunction) {
    final result = moveFunction();
    if (result['moved'] as bool) {
      _makeMove(result['scoreGained'] as int);
    }
  }

  Map<String, dynamic> _processRowsLeft() {
    bool moved = false;
    int scoreGained = 0;

    for (int i = 0; i < gridSize; i++) {
      final result = _processLine(_gameState.grid[i]);
      if (result['moved']) {
        moved = true;
        scoreGained += result['score'] as int;
        _gameState.grid[i] = List<int?>.from(result['line']);
      }
    }
    return {'moved': moved, 'scoreGained': scoreGained};
  }

  Map<String, dynamic> _processRowsRight() {
    bool moved = false;
    int scoreGained = 0;

    for (int i = 0; i < gridSize; i++) {
      final reversedRow = _gameState.grid[i].reversed.toList();
      final result = _processLine(reversedRow);
      if (result['moved']) {
        moved = true;
        scoreGained += result['score'] as int;
        _gameState.grid[i] = (result['line'] as List<int?>).reversed.toList();
      }
    }
    return {'moved': moved, 'scoreGained': scoreGained};
  }

  Map<String, dynamic> _processColumnsUp() {
    bool moved = false;
    int scoreGained = 0;

    for (int j = 0; j < gridSize; j++) {
      final column = <int?>[];
      for (int i = 0; i < gridSize; i++) {
        column.add(_gameState.grid[i][j]);
      }
      
      final result = _processLine(column);
      if (result['moved']) {
        moved = true;
        scoreGained += result['score'] as int;
        final processedColumn = result['line'] as List<int?>;
        for (int i = 0; i < gridSize; i++) {
          _gameState.grid[i][j] = processedColumn[i];
        }
      }
    }
    return {'moved': moved, 'scoreGained': scoreGained};
  }

  Map<String, dynamic> _processColumnsDown() {
    bool moved = false;
    int scoreGained = 0;

    for (int j = 0; j < gridSize; j++) {
      final column = <int?>[];
      for (int i = gridSize - 1; i >= 0; i--) {
        column.add(_gameState.grid[i][j]);
      }
      
      final result = _processLine(column);
      if (result['moved']) {
        moved = true;
        scoreGained += result['score'] as int;
        final processedColumn = (result['line'] as List<int?>).reversed.toList();
        for (int i = 0; i < gridSize; i++) {
          _gameState.grid[i][j] = processedColumn[i];
        }
      }
    }
    return {'moved': moved, 'scoreGained': scoreGained};
  }

  Map<String, dynamic> _processLine(List<int?> line) {
    final original = List<int?>.from(line);
    final nonNull = line.where((cell) => cell != null).toList();
    final merged = <int?>[];
    int score = 0;
    int i = 0;

    while (i < nonNull.length) {
      if (i < nonNull.length - 1 && nonNull[i] == nonNull[i + 1]) {
        final newLevel = nonNull[i]! + 1;
        merged.add(newLevel <= AIComponent.components.length ? newLevel : nonNull[i]);
        final component = AIComponent.getComponentByLevel(newLevel);
        score += component?.points ?? 0;
        i += 2;
      } else {
        merged.add(nonNull[i]);
        i++;
      }
    }

    while (merged.length < gridSize) {
      merged.add(null);
    }

    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      if (original[j] != merged[j]) {
        moved = true;
        break;
      }
    }

    return {'line': merged, 'moved': moved, 'score': score};
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

    if (!canMove() && _extraMoves <= 0) {
      _gameState = _gameState.copyWith(gameOver: true);
    }

    if (scoreGained > 0) {
      _vibrate();
    }

    notifyListeners();
  }

  void _vibrate() {
    try {
      Vibration.vibrate(duration: 50);
    } catch (e) {
      print('Vibration error: $e');
    }
  }

  void useExtraMove() {
    if (_extraMoves > 0 && _gameState.gameOver) {
      _extraMoves--;
      _gameState = _gameState.copyWith(gameOver: false);
      notifyListeners();
    }
  }

  void addExtraMovesFromAd(int moves) {
    _extraMoves += moves;
    if (_gameState.gameOver) {
      _gameState = _gameState.copyWith(gameOver: false);
    }
    notifyListeners();
  }

  void resetGame() {
    _initializeGame();
    notifyListeners();
  }
}