import 'package:flame/components.dart';
import 'package:shadow_drift/game/my_world.dart';
import 'package:flame/collisions.dart';
import 'player.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyWorld> {
  final double fallSpeed = 150;
  final double speedMultiplier;
  bool hasScored = false;

  Enemy({required Vector2 position, required this.speedMultiplier}) {
    this.position = position;
    size = Vector2(48, 48);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('enemy.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += fallSpeed * speedMultiplier * dt;

    if (!hasScored &&
        position.y > gameRef.player.position.y + gameRef.player.size.y) {
      hasScored = true;
      gameRef.updateScore(1);
    }

    if (position.y > gameRef.player.position.y + 600) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.triggerGameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
