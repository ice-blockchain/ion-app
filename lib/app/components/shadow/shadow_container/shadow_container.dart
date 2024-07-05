import 'package:flutter/material.dart';
import 'package:ice/app/extensions/theme_data.dart';

class CustomBoxShadow extends StatelessWidget {
  const CustomBoxShadow({
    required this.child,
    super.key,
    this.boxShadow,
  });

  final Widget child;
  final BoxShadow? boxShadow;

  static const BoxShadow defaultBoxShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.5),
    offset: Offset(0, -1),
    blurRadius: 5,
  );

  @override
  Widget build(BuildContext context) {
    final shadow = boxShadow ??
        BoxShadow(
          color: Theme.of(context).appColors.strokeElements.withOpacity(0.5),
          offset: const Offset(0, -1),
          blurRadius: 5,
        );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [shadow],
      ),
      child: child,
    );
  }
}
