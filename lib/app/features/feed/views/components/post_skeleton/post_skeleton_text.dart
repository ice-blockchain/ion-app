import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class PostSkeletonText extends StatelessWidget {
  const PostSkeletonText({
    super.key,
    this.widthFactor = 1,
  });

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.5.s),
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 12.0.s,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0.s),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
