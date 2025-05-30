import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:shadow_drift/game/player.dart';
import 'package:shadow_drift/game/my_world.dart';

class FinishLine extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyWorld> {
  FinishLine({required Vector2 position}) {
    this.position = Vector2(position.x, position.y - 35);
    size = Vector2(30, 70); // Eskisi 32x100 idi
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('finishline.png');
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.completeLevel();
    }
    super.onCollision(intersectionPoints, other);
  }
}
