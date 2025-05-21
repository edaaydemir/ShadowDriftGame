import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:shadow_drift/game/my_world.dart';
import 'package:shadow_drift/game/player.dart';

/// 🌵 CactusObstacle: çarpınca game over
class CactusObstacle extends SpriteComponent
    with HasGameRef<MyWorld>, CollisionCallbacks {
  CactusObstacle() {
    size = Vector2(40, 60);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('cactus.png');
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Player) {
      gameRef.triggerGameOver();
    }
  }
}

class SpringObstacle extends SpriteAnimationComponent
    with HasGameRef<MyWorld>, CollisionCallbacks {
  bool triggered = false;
  double cooldownTimer = 0.0;
  double cooldownDuration = 1.0;

  SpringObstacle() {
    size = Vector2(40, 50);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    final springFrames = [
      await gameRef.loadSprite('spring.png'),
      await gameRef.loadSprite('spring_in.png'),
      await gameRef.loadSprite('spring_out.png'),
    ];

    animation = SpriteAnimation.spriteList(springFrames, stepTime: 0.1);

    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Player && !triggered) {
      other.velocity.y = other.jumpSpeed * 2;
      triggered = true;
      cooldownTimer = 0.0;
      animationTicker?.reset(); // 🔁 doğru kullanım
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (triggered) {
      cooldownTimer += dt;
      if (cooldownTimer >= cooldownDuration) {
        triggered = false;
        cooldownTimer = 0.0;
        animationTicker?.reset(); // 🔁 animasyonu başa al
      }
    }
  }
}

/// 🌿 GrassObstacle: sadece dekor, çarpma yok
class GrassObstacle extends SpriteComponent with HasGameRef<MyWorld> {
  GrassObstacle() {
    size = Vector2(30, 30);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    final grassAssets = ['grass1.png', 'grass2.png'];
    final chosen = grassAssets[gameRef.random.nextInt(grassAssets.length)];
    sprite = await Sprite.load(chosen);
  }
}

/// 🪨 GrassGroundObstacle: üzerine çıkılabilir
class GrassGroundObstacle extends SpriteComponent
    with HasGameRef<MyWorld>, CollisionCallbacks {
  GrassGroundObstacle() {
    size = Vector2(60, 40);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('ground_grass.png');
    add(RectangleHitbox());
  }
}

/// 🏖️ SandPlatform: üzerine çıkılabilir
class SandPlatform extends SpriteComponent
    with HasGameRef<MyWorld>, CollisionCallbacks {
  SandPlatform() {
    size = Vector2(100, 40);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('ground_sand.png');
    add(RectangleHitbox());
  }
}

/// ❄️ SnowPlatform: üzerine çıkılabilir
class SnowPlatform extends SpriteComponent
    with HasGameRef<MyWorld>, CollisionCallbacks {
  SnowPlatform() {
    size = Vector2(100, 40);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('ground_snow.png');
    add(RectangleHitbox());
  }
}
