import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/game_provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/game_board.dart';
import '../widgets/score_display.dart';
import '../widgets/game_controls.dart';
import '../widgets/ad_banner.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Load ads when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adProvider = Provider.of<AdProvider>(context, listen: false);
      adProvider.loadBannerAd();
      adProvider.loadInterstitialAd();
      adProvider.loadRewardedAd();
    });
  }

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
          child: Consumer2<GameProvider, AdProvider>(
            builder: (context, gameProvider, adProvider, child) {
              // Show interstitial ad after game over
              if (gameProvider.gameState.gameOver && adProvider.isInterstitialAdReady) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  adProvider.showInterstitialAd();
                });
              }
              
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
                  
                  // Banner Ad
                  const AdBanner(),
                  
                  // Game Board
                  Expanded(
                    child: Center(
                      child: GameBoard(gameState: gameProvider.gameState),
                    ),
                  ),
                  
                  // Game Over Dialog with Reward Ad
                  if (gameProvider.gameState.gameOver)
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.accent, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'GAME OVER',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Final Score: ${gameProvider.gameState.score}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: gameProvider.resetGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('NEW GAME'),
                              ),
                              if (adProvider.isRewardedAdReady)
                                ElevatedButton(
                                  onPressed: () {
                                    adProvider.showRewardedAd(
                                      onRewarded: () {
                                        gameProvider.addExtraMovesFromAd(
                                          GameConstants.extraMovesFromAd,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'You got ${GameConstants.extraMovesFromAd} extra moves!',
                                            ),
                                            backgroundColor: AppColors.accent,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('WATCH AD\n+5 MOVES'),
                                ),
                            ],
                          ),
                        ],
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