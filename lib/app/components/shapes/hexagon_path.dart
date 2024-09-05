import 'package:flutter/material.dart';
import 'package:ice/app/components/shapes/shape.dart';

class HexagonShapeBuilder extends ShapeBuilder {
  HexagonShapeBuilder();

  Path build(Size size) {
    Path path = Path();

    path.lineTo(size.width * 0.37, size.height * 0.02);
    path.cubicTo(
        size.width * 0.43, -0.01, size.width / 2, -0.01, size.width * 0.56, size.height * 0.02);
    path.cubicTo(size.width * 0.56, size.height * 0.02, size.width * 0.84, size.height * 0.18,
        size.width * 0.84, size.height * 0.18);
    path.cubicTo(size.width * 0.9, size.height * 0.22, size.width * 0.94, size.height * 0.28,
        size.width * 0.94, size.height * 0.35);
    path.cubicTo(size.width * 0.94, size.height * 0.35, size.width * 0.94, size.height * 0.65,
        size.width * 0.94, size.height * 0.65);
    path.cubicTo(size.width * 0.94, size.height * 0.72, size.width * 0.9, size.height * 0.78,
        size.width * 0.84, size.height * 0.82);
    path.cubicTo(size.width * 0.84, size.height * 0.82, size.width * 0.56, size.height * 0.98,
        size.width * 0.56, size.height * 0.98);
    path.cubicTo(size.width / 2, size.height, size.width * 0.43, size.height, size.width * 0.37,
        size.height * 0.98);
    path.cubicTo(size.width * 0.37, size.height * 0.98, size.width * 0.1, size.height * 0.82,
        size.width * 0.1, size.height * 0.82);
    path.cubicTo(
        size.width * 0.04, size.height * 0.78, 0, size.height * 0.72, 0, size.height * 0.65);
    path.cubicTo(0, size.height * 0.65, 0, size.height * 0.35, 0, size.height * 0.35);
    path.cubicTo(0, size.height * 0.28, size.width * 0.04, size.height * 0.22, size.width * 0.1,
        size.height * 0.18);
    path.cubicTo(size.width * 0.1, size.height * 0.18, size.width * 0.37, size.height * 0.02,
        size.width * 0.37, size.height * 0.02);
    path.cubicTo(size.width * 0.37, size.height * 0.02, size.width * 0.37, size.height * 0.02,
        size.width * 0.37, size.height * 0.02);
    return path.shift(Offset(size.width * 0.03, 0));
  }
}
