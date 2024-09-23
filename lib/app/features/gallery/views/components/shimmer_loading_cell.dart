import 'package:flutter/material.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/extensions.dart';

class ShimmerLoadingCell extends StatelessWidget {
  const ShimmerLoadingCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: SizedBox(
        width: 122.0.s,
        height: 120.0.s,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
