import 'package:flutter/material.dart';

class TextInputBorder extends InputBorder {
  /// Creates a rounded rectangle outline border for an [InputDecorator].
  ///
  /// If the [borderSide] parameter is [BorderSide.none], it will not draw a
  /// border. However, it will still define a shape (which you can see if
  /// [InputDecoration.filled] is true).
  ///
  /// If an application does not specify a [borderSide] parameter of
  /// value [BorderSide.none], the input decorator substitutes its own, using
  /// [copyWith], based on the current theme and [InputDecorator.isFocused].
  ///
  /// The [borderRadius] parameter defaults to a value where all four
  /// corners have a circular radius of 4.0. The [borderRadius] parameter
  /// must not be null and the corner radii must be circular, i.e. their
  /// [Radius.x] and [Radius.y] values must be the same.
  ///
  /// See also:
  ///
  ///  * [InputDecoration.floatingLabelBehavior], which should be set to
  ///    [FloatingLabelBehavior.never] when the [borderSide] is
  ///    [BorderSide.none]. If let as [FloatingLabelBehavior.auto], the label
  ///    will extend beyond the container as if the border were still being
  ///    drawn.
  const TextInputBorder({
    super.borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  });

  /// The radii of the border's rounded rectangle corners.
  ///
  /// The corner radii must be circular, i.e. their [Radius.x] and [Radius.y]
  /// values must be the same.
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
      final TextInputBorder outline = a;
      return TextInputBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is TextInputBorder) {
      final TextInputBorder outline = b;
      return TextInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        borderRadius
            .resolve(textDirection)
            .toRRect(rect)
            .deflate(borderSide.width),
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

  /// Draw a rounded rectangle around [rect] using [borderRadius].
  ///
  /// The [borderSide] defines the line's color and weight.
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);
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
