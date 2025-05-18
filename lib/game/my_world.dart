import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:shadow_drift/game/player.dart';
import 'package:shadow_drift/game/enemy.dart';
import 'package:shadow_drift/game/finish_line.dart';
import 'package:shadow_drift/game/background.dart';

class MyWorld extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;
  FinishLine? finishLine;
  late TextComponent scoreText;
  late Background background;

  final Random random = Random();
  double spawnTimer = 0;
  double spawnInterval = 1.5;

  int score = 0;
  int level = 1;
  bool isLevelComplete = false;
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    background = Background();
    add(background);

    player = Player()..position = Vector2(0, 536);
    add(player);

    camera.follow(player);
    camera.viewfinder.zoom = 1.2;
    camera.viewfinder.anchor = Anchor(0.5, 0.7);

    scoreText = TextComponent(
      text: 'Level: $level   Score: $score',
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
      priority: 100,
    );
    add(scoreText);

    spawnFinishLine();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isLevelComplete || isGameOver) return;

    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnEnemy();
      spawnTimer = 0;
    }
  }

  void spawnEnemy() {
    final x = player.position.x + random.nextDouble() * 300;
    final enemy = Enemy(
      position: Vector2(x, -48),
      speedMultiplier: 1.0 + (level - 1) * 0.2,
    );
    add(enemy);
  }

  void spawnFinishLine() {
    final x = player.position.x + 1000;
    final y = 536;
    finishLine = FinishLine(position: Vector2(x, y.toDouble()));
    add(finishLine!);
  }

  void updateScore(int value) {
    score += value;
    scoreText.text = 'Level: $level   Score: $score';
  }

  void completeLevel() {
    isLevelComplete = true;
    pauseEngine();
    overlays.add('LevelComplete');
  }

  void triggerGameOver() {
    isGameOver = true;
    pauseEngine();
    overlays.add('GameOver');
  }

  void resetLevel() {
    score = 0;
    level = 1;
    isLevelComplete = false;
    isGameOver = false;
    spawnInterval = 1.5;
    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    finishLine?.removeFromParent();
    player.position = Vector2(64, 536);
    updateScore(0);
    spawnFinishLine();
    resumeEngine();
  }

  void nextLevel() {
    level++;
    isLevelComplete = false;
    spawnInterval = (spawnInterval - 0.1).clamp(0.5, 2.0);
    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    finishLine?.removeFromParent();
    player.position = Vector2(64, 536);
    spawnFinishLine();
    resumeEngine();
  }
}
