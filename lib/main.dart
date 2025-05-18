import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shadow_drift/game/my_world.dart';
import 'package:shadow_drift/game/gameOver_overlay.dart';
import 'package:shadow_drift/game/level_complete_overlay.dart';

void main() {
  final game = MyWorld();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'GameOver': (context, _) => GameOverOverlay(
                  score: game.score,
                  gameRef: game,
                ),
            'LevelComplete': (context, _) => LevelCompleteOverlay(
                  score: game.score,
                  gameRef: game,
                ),
          },
        ),
      ),
    ),
  );
}
