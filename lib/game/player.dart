import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadow_drift/game/my_world.dart';

class Player extends SpriteComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<MyWorld> {
  final double moveSpeed = 200;
  final double jumpSpeed = -400;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = true;

  Player() {
    size = Vector2(70, 70);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bluecharacter.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;

    if (!isOnGround) {
      velocity.y += 800 * dt; 
    }

    if (position.y >= 536) {
      position.y = 536;
      isOnGround = true;
      velocity.y = 0;
    }
  }

  @override
  bool onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    velocity.x = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -moveSpeed;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = moveSpeed;
    }

    if (keysPressed.contains(LogicalKeyboardKey.space) && isOnGround) {
      velocity.y = jumpSpeed;
      isOnGround = false;
    }

    return true; // Indicate the event was handled
  }
}
