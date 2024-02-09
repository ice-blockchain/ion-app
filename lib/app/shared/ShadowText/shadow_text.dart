import 'package:flutter/material.dart';

class ShadowText extends StatelessWidget {
  const ShadowText({
    super.key,
    required this.child,
    TextStyle? shadowStyle,
  }) : shadowStyle = shadowStyle ?? defaultShadowStyle;

  final Widget child;
  final TextStyle shadowStyle;

  static const TextStyle defaultShadowStyle = TextStyle(
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0, 0.5),
        color: Color.fromRGBO(0, 0, 0, 0.4),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: shadowStyle,
      child: child,
    );
  }
}
