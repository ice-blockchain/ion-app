import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
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
          height: UiSize.medium,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiSize.xSmall),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
