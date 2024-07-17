import 'package:flutter/material.dart';

class PostMetricSpace extends StatelessWidget {
  const PostMetricSpace({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        // TODO: Get rid of IntrinsicWidth
        child: IntrinsicWidth(
          child: child,
        ),
      ),
    );
  }
}
