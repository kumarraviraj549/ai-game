import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/ai_component.dart';
import '../utils/constants.dart';
import 'component_tile.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;

  const GameBoard({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boardSize = screenWidth * 0.85;
    final tileSize = (boardSize - 50) / 4; // 50 for padding between tiles

    return Container(
      width: boardSize,
      height: boardSize,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.boardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background grid
          for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
              Positioned(
                left: j * (tileSize + 10),
                top: i * (tileSize + 10),
                child: Container(
                  width: tileSize,
                  height: tileSize,
                  decoration: BoxDecoration(
                    color: AppColors.emptyTile,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          
          // Game tiles
          for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
              if (gameState.grid[i][j] != null)
                Positioned(
                  left: j * (tileSize + 10),
                  top: i * (tileSize + 10),
                  child: ComponentTile(
                    component: AIComponent.getComponentByLevel(gameState.grid[i][j]!)!,
                    size: tileSize,
                  ),
                ),
          
          // Game Over Overlay
          if (gameState.gameOver)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'GAME OVER',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}