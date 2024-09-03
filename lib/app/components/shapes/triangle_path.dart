import 'package:flutter/material.dart';
import 'package:ice/app/components/shapes/shape.dart';

class TriangleShapeBuilder extends ShapeBuilder {
  @override
  Path build(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }
}
