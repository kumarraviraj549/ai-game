import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/game_screen.dart';
import 'providers/game_provider.dart';
import 'utils/constants.dart';

void main() {
  runApp(const AIMergeLabApp());
}

class AIMergeLabApp extends StatelessWidget {
  const AIMergeLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'AI Merge Lab',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Orbitron',
        ),
        home: const GameScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}