import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class TextInputBorder extends InputBorder {
  TextInputBorder({
    super.borderSide = const BorderSide(),
    BorderRadius? borderRadius,
  }) : borderRadius = borderRadius ?? BorderRadius.all(Radius.circular(16.0.s));

  final BorderRadius borderRadius;

  @override
  bool get isOutline => false;

  @override
  TextInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
  }) {
    return TextInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  TextInputBorder scale(double t) {
    return TextInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is TextInputBorder) {
      final outline = a;
      return TextInputBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t),
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is TextInputBorder) {
      final outline = b;
      return TextInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t),
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        borderRadius.resolve(textDirection).toRRect(rect).deflate(borderSide.width),
      );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final paint = borderSide.toPaint();
    final outer = borderRadius.toRRect(rect);
    final center = outer.deflate(borderSide.width / 2.0);
    canvas.drawRRect(center, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TextInputBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius);
}
