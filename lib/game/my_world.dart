import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:shadow_drift/game/player.dart';
import 'package:shadow_drift/game/enemy.dart';
import 'package:shadow_drift/game/finish_line.dart';
import 'package:shadow_drift/game/background.dart';
import 'package:shadow_drift/game/obstacles.dart';

class MyWorld extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
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

    player = Player()..position = Vector2(64, size.y);
    add(player);

    scoreText = TextComponent(
      text: 'Level: $level   Score: $score',
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
      priority: 100,
    );
    add(scoreText);

    spawnFinishLine();
    spawnEnvironment();
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
    final x = random.nextDouble() * size.x;
    final enemy = Enemy(
      position: Vector2(x, -48),
      speedMultiplier: 1.0 + (level - 1) * 0.3,
    );
    add(enemy);
  }

  void spawnFinishLine() {
    final x = size.x - 40;
    finishLine = FinishLine(position: Vector2(x, size.y));
    add(finishLine!);
  }

  void spawnEnvironment() {
    final startX = player.position.x + 200;
    final endX = finishLine?.position.x ?? size.x;

    final layers = [size.y - 60, size.y - 110, size.y - 160];

    final usedZones = <int>{};
    const zoneSize = 80;

    double x = startX;

    final platformFactories = [
      () => GrassGroundObstacle(),
      () => SandPlatform(),
      () => SnowPlatform(),
    ];

    final obstacleFactories = [() => CactusObstacle(), () => SpringObstacle()];

    final decorFactories = [() => GrassObstacle()];

    while (x < endX - 100) {
      final zone = (x / zoneSize).floor();
      if (usedZones.contains(zone)) {
        x += 40;
        continue;
      }
      usedZones.add(zone);

      final y = layers[random.nextInt(layers.length)];

      // Platform ekle
      final platform =
          platformFactories[random.nextInt(platformFactories.length)]();
      platform.position = Vector2(x, y);
      add(platform);

      // Dekor (çimen gibi)
      if (random.nextDouble() < 0.3) {
        final decor = decorFactories[random.nextInt(decorFactories.length)]();
        decor.position = Vector2(x, y);
        add(decor);
      }

      // Engel (spring / cactus) eklensin mi
      if (random.nextDouble() < 0.4) {
        final obstacle =
            obstacleFactories[random.nextInt(obstacleFactories.length)]();
        obstacle.position = Vector2(x + 20, size.y);
        add(obstacle);
      }

      x += 100 + random.nextDouble() * 50;
    }
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
    clearObstacles(); // ✅ EKLENDİ

    player.position = Vector2(64, size.y);
    updateScore(0);
    spawnFinishLine();
    spawnEnvironment();
    resumeEngine();
  }

  void nextLevel() {
    level++;
    isLevelComplete = false;
    spawnInterval = (spawnInterval - 0.1).clamp(0.3, 2.0);

    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    finishLine?.removeFromParent();
    clearObstacles(); // ✅ EKLENDİ

    player.position = Vector2(64, size.y);
    spawnFinishLine();
    spawnEnvironment();
    resumeEngine();
  }

  void clearObstacles() {
    children.whereType<SpriteComponent>().forEach((component) {
      if (component is CactusObstacle ||
          component is SpringObstacle ||
          component is GrassObstacle ||
          component is GrassGroundObstacle ||
          component is SandPlatform ||
          component is SnowPlatform) {
        component.removeFromParent();
      }
    });
  }
}
