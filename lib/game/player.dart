import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:shadow_drift/game/my_world.dart';
import 'package:shadow_drift/game/obstacles.dart';

class Player extends SpriteComponent
    with HasGameRef<MyWorld>, KeyboardHandler, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  double speed = 200;
  double gravity = 800;
  double jumpSpeed = -400;
  bool isOnGround = false;

  Player() {
    size = Vector2(50, 50);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bluecharacter.png');
    position = Vector2(64, gameRef.size.y);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Gravity
    if (!isOnGround) {
      velocity.y += gravity * dt;
    }

    // Apply movement
    position += velocity * dt;

    // Yere düştüyse
    if (position.y > gameRef.size.y) {
      position.y = gameRef.size.y;
      velocity.y = 0;
      isOnGround = true;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        velocity.x = -speed;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = speed;
      } else if (event.logicalKey == LogicalKeyboardKey.space && isOnGround) {
        velocity.y = jumpSpeed;
        isOnGround = false;
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = 0;
      }
    }
    return true;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    // Platformlara değdiğinde
    if (other is GrassGroundObstacle ||
        other is SandPlatform ||
        other is SnowPlatform) {
      if (velocity.y > 0) {
        // Sadece yukarıdan çarptıysa zemin kabul et
        isOnGround = true;
        velocity.y = 0;
        position.y = other.toRect().top - 1;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is GrassGroundObstacle ||
        other is SandPlatform ||
        other is SnowPlatform) {
      isOnGround = false;
    }
  }
}
