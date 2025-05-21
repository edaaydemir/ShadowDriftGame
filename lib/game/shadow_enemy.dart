import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:shadow_drift/game/my_world.dart';
import 'package:shadow_drift/game/player.dart';

class ShadowEnemy extends SpriteComponent
    with HasGameRef<MyWorld>, CollisionCallbacks {
  final double speed;

  ShadowEnemy({required this.speed}) {
    size = Vector2(30, 30);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('redcharacter.png'); 
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    final playerX = gameRef.player.position.x;
    if (x < playerX) {
      x += speed * dt;
    }
    y = gameRef.size.y - 35;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Player) {
      gameRef.triggerGameOver();
    }
  }
}
