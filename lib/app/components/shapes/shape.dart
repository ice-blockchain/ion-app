import 'package:flutter/material.dart';

abstract class ShapeBuilder {
  Path build(Size size);
}

class ShapeClipper extends CustomClipper<Path> {
  ShapeClipper(this.shapeBuilder);

  final ShapeBuilder shapeBuilder;

  @override
  Path getClip(Size size) {
    return shapeBuilder.build(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ShapePainter extends CustomPainter {
  ShapePainter(this.shapeBuilder, {required this.color});

  final Color color;

  final ShapeBuilder shapeBuilder;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = shapeBuilder.build(size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
