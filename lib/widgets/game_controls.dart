import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class GameControls extends StatefulWidget {
  final GameProvider gameProvider;

  const GameControls({super.key, required this.gameProvider});

  @override
  State<GameControls> createState() => _GameControlsState();
}

class _GameControlsState extends State<GameControls> {
  @override
  void initState() {
    super.initState();
    // Enable raw keyboard listener
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleKeyPress,
      child: GestureDetector(
        onPanEnd: _handlePanEnd,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Swipe Instructions
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: const Text(
                  'Swipe to move tiles\nMerge same AI components!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              // Direction buttons (backup for swipe)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDirectionButton(
                    icon: Icons.keyboard_arrow_left,
                    onPressed: widget.gameProvider.moveLeft,
                  ),
                  Column(
                    children: [
                      _buildDirectionButton(
                        icon: Icons.keyboard_arrow_up,
                        onPressed: widget.gameProvider.moveUp,
                      ),
                      const SizedBox(height: 10),
                      _buildDirectionButton(
                        icon: Icons.keyboard_arrow_down,
                        onPressed: widget.gameProvider.moveDown,
                      ),
                    ],
                  ),
                  _buildDirectionButton(
                    icon: Icons.keyboard_arrow_right,
                    onPressed: widget.gameProvider.moveRight,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              // Reset button
              ElevatedButton(
                onPressed: _showResetDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'NEW GAME',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 30,
        color: AppColors.accent,
      ),
    );
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          widget.gameProvider.moveLeft();
          break;
        case LogicalKeyboardKey.arrowRight:
          widget.gameProvider.moveRight();
          break;
        case LogicalKeyboardKey.arrowUp:
          widget.gameProvider.moveUp();
          break;
        case LogicalKeyboardKey.arrowDown:
          widget.gameProvider.moveDown();
          break;
      }
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    final velocity = details.velocity;
    const threshold = 500.0; // Minimum velocity for swipe detection

    if (velocity.pixelsPerSecond.dx.abs() > velocity.pixelsPerSecond.dy.abs()) {
      // Horizontal swipe
      if (velocity.pixelsPerSecond.dx > threshold) {
        widget.gameProvider.moveRight();
      } else if (velocity.pixelsPerSecond.dx < -threshold) {
        widget.gameProvider.moveLeft();
      }
    } else {
      // Vertical swipe
      if (velocity.pixelsPerSecond.dy > threshold) {
        widget.gameProvider.moveDown();
      } else if (velocity.pixelsPerSecond.dy < -threshold) {
        widget.gameProvider.moveUp();
      }
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            'New Game',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'Are you sure you want to start a new game? Current progress will be lost.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.gameProvider.resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
              ),
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }
}