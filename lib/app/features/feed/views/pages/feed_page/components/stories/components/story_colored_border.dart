import 'package:flutter/material.dart';
import 'package:ice/app/components/shapes/hexagon_path.dart';
import 'package:ice/app/components/shapes/shape.dart';

class StoryColoredBorder extends StatelessWidget {
  const StoryColoredBorder({required this.size, super.key,
    this.hexagon = false,
    this.color,
    this.gradient,
    this.child,
  });

  final double size;

  final bool hexagon;

  final Color? color;

  final Gradient? gradient;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: hexagon
          ? CustomPaint(
              size: Size.square(size),
              painter: ShapePainter(
                HexagonShapeBuilder(),
                color: color,
                shader: gradient?.createShader(
                  Rect.fromCircle(center: Offset(size / 2, size / 2), radius: size / 2),
                ),
              ),
              child: Center(child: child),
            )
          : Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(size * 0.3),
                color: color,
              ),
              child: Center(child: child),
            ),
    );
  }
}
