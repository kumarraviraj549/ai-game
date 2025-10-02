class GameState {
  final List<List<int?>> grid;
  final int score;
  final int moves;
  final bool gameOver;
  final int highScore;

  GameState({
    required this.grid,
    required this.score,
    required this.moves,
    required this.gameOver,
    required this.highScore,
  });

  GameState copyWith({
    List<List<int?>>? grid,
    int? score,
    int? moves,
    bool? gameOver,
    int? highScore,
  }) {
    return GameState(
      grid: grid ?? this.grid.map((row) => List<int?>.from(row)).toList(),
      score: score ?? this.score,
      moves: moves ?? this.moves,
      gameOver: gameOver ?? this.gameOver,
      highScore: highScore ?? this.highScore,
    );
  }
}