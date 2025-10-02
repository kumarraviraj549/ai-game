import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0F);
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color accent = Color(0xFF00D4FF);
  static const Color cardBackground = Color(0xFF16213E);
  static const Color boardBackground = Color(0xFF0F1B35);
  static const Color emptyTile = Color(0xFF1E2A47);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3B8);
  static const Color adBackground = Color(0xFF2A2A3E);
}

class GameConstants {
  static const int gridSize = 4;
  static const int maxComponentLevel = 8;
  static const double tileAnimationDuration = 200;
  static const double mergeAnimationDuration = 300;
  static const int extraMovesFromAd = 5;
}

class AdConstants {
  // Test Ad Unit IDs - Replace with your actual Ad Unit IDs for production
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  
  // Production Ad Unit IDs (replace these with your actual IDs)
  // static const String bannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  // static const String interstitialAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  // static const String rewardedAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
}