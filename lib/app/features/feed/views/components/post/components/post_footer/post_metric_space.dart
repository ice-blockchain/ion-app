import 'package:flutter/material.dart';

class PostMetricSpace extends StatelessWidget {
  const PostMetricSpace({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(
          child: child,
        ),
      ),
    );
  }
}
