import 'package:flutter/material.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/extensions.dart';

class ShimmerLoadingCell extends StatelessWidget {
  const ShimmerLoadingCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Container(
        width: 122.0.s,
        height: 120.0.s,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
      ),
    );
  }
}
