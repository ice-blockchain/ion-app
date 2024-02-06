import 'package:flutter/material.dart';

class SidePadding extends StatelessWidget {
  const SidePadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: child,
    );
  }
}
