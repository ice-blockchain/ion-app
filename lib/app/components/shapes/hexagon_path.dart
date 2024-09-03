import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ice/app/components/shapes/shape.dart';

class HexagonShapeBuilder extends ShapeBuilder {
  final double borderRadius;

  HexagonShapeBuilder({this.borderRadius = 0});

  Path build(Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final cornerList = List.generate(6, (index) {
      final angleDeg = 60 * index - 30;
      final angleRad = pi / 180 * angleDeg;
      return Point(center.dx + (size.width / 2) * cos(angleRad),
          center.dy + (size.height / 2) * sin(angleRad));
    });

    final path = Path();
    if (borderRadius > 0) {
      cornerList.asMap().forEach((index, point) {
        final rStart = _radiusStart(point, index, cornerList, borderRadius);
        final rEnd = _radiusEnd(point, index, cornerList, borderRadius);
        if (index == 0) {
          path.moveTo(rStart.x, rStart.y);
        } else {
          path.lineTo(rStart.x, rStart.y);
        }

        final control1 = _pointBetween(rStart, point, fraction: 0.7698);
        final control2 = _pointBetween(rEnd, point, fraction: 0.7698);

        path.cubicTo(
          control1.x,
          control1.y,
          control2.x,
          control2.y,
          rEnd.x,
          rEnd.y,
        );
      });
    } else {
      cornerList.asMap().forEach((index, point) {
        if (index == 0) {
          path.moveTo(point.x, point.y);
        } else {
          path.lineTo(point.x, point.y);
        }
      });
    }

    return path..close();
  }

  Point<double> _pointBetween(Point<double> start, Point<double> end,
      {double? distance, double? fraction}) {
    double xLength = end.x - start.x;
    double yLength = end.y - start.y;
    if (fraction == null) {
      if (distance == null) {
        throw Exception('Distance or fraction should be specified.');
      }
      double length = sqrt(xLength * xLength + yLength * yLength);
      fraction = distance / length;
    }
    return Point(start.x + xLength * fraction, start.y + yLength * fraction);
  }

  Point<double> _radiusStart(
      Point<double> corner, int index, List<Point<double>> cornerList, double radius) {
    final prevCorner = index > 0 ? cornerList[index - 1] : cornerList[cornerList.length - 1];
    double distance = radius * tan(pi / 6);
    return _pointBetween(corner, prevCorner, distance: distance);
  }

  Point<double> _radiusEnd(
      Point<double> corner, int index, List<Point<double>> cornerList, double radius) {
    final nextCorner = index < cornerList.length - 1 ? cornerList[index + 1] : cornerList[0];
    double distance = radius * tan(pi / 6);
    return _pointBetween(corner, nextCorner, distance: distance);
  }
}
