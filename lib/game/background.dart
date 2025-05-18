import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';

class Background extends ParallaxComponent {
  @override
  Future<void> onLoad() async {
    parallax = await Parallax.load(
      [
        ParallaxImageData('background.png'),
      ],
      baseVelocity: Vector2(20, 0), // yatayda hareket
      repeat: ImageRepeat.repeatX,
    );
  }
}
