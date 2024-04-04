import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  TrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(0, 0); // Start at the bottom left
    path.lineTo(size.width / 2, size.height); // Draw line to the top middle
    path.lineTo(size.width, 0); // Draw line to the bottom right
    path.close(); // Close the path to automatically draw a line back to the starting point

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
