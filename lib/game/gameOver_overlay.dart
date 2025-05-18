// ✅ gameOver_overlay.dart — Yeni mimariye uygun Game Over arayüzü
import 'package:flutter/material.dart';
import 'package:shadow_drift/game/my_world.dart';

class GameOverOverlay extends StatelessWidget {
  final int score;
  final MyWorld gameRef;

  const GameOverOverlay({
    Key? key,
    required this.score,
    required this.gameRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(fontSize: 32, color: Colors.red),
          ),
          const SizedBox(height: 16),
          Text(
            'Score: $score',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              gameRef.resetLevel();
              gameRef.findGame()?.overlays.remove('GameOver');
              gameRef.findGame()?.resumeEngine();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}