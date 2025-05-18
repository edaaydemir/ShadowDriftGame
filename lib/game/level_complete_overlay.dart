// ✅ level_complete_overlay.dart — Yeni mimariye uygun seviye geçiş arayüzü
import 'package:flutter/material.dart';
import 'package:shadow_drift/game/my_world.dart';

class LevelCompleteOverlay extends StatelessWidget {
  final int score;
  final MyWorld gameRef;

  const LevelCompleteOverlay({
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
            'Level Complete!',
            style: TextStyle(fontSize: 32, color: Colors.greenAccent),
          ),
          const SizedBox(height: 16),
          Text(
            'Score: $score',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              gameRef.nextLevel();
              gameRef.findGame()?.overlays.remove('LevelComplete');
              gameRef.findGame()?.resumeEngine();
            },
            child: const Text('Next Level'),
          ),
        ],
      ),
    );
  }
}