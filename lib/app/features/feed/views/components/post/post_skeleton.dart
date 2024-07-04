import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 14.5.s,
              bottom: 10.5.s,
            ),
            child: Container(
              height: 32.0.s,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0.s),
                color: Colors.white,
              ),
            ),
          ),
          const _PostSkeletonText(widthFactor: 0.8),
          const _PostSkeletonText(),
          const _PostSkeletonText(),
          const _PostSkeletonText(
            widthFactor: 0.4,
          ),
        ],
      ),
    );
  }
}

class _PostSkeletonText extends StatelessWidget {
  const _PostSkeletonText({
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
