import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';

class ScoreDisplay extends StatelessWidget {
  final GameState gameState;

  const ScoreDisplay({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreCard('SCORE', gameState.score),
        _buildScoreCard('BEST', gameState.highScore),
        _buildScoreCard('MOVES', gameState.moves),
      ],
    );
  }

  Widget _buildScoreCard(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}