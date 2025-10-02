import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_board.dart';
import '../widgets/score_display.dart';
import '../widgets/game_controls.dart';
import '../utils/constants.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDark,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return Column(
                children: [
                  // Header with title and score
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'AI MERGE LAB',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ScoreDisplay(gameState: gameProvider.gameState),
                      ],
                    ),
                  ),
                  
                  // Game Board
                  Expanded(
                    child: Center(
                      child: GameBoard(gameState: gameProvider.gameState),
                    ),
                  ),
                  
                  // Game Controls
                  GameControls(gameProvider: gameProvider),
                  
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}