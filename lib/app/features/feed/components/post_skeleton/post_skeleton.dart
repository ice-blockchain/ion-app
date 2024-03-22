import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/components/post_skeleton/post_skeleton_text.dart';

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
          const PostSkeletonText(widthFactor: 0.8),
          const PostSkeletonText(),
          const PostSkeletonText(),
          const PostSkeletonText(
            widthFactor: 0.4,
          ),
        ],
      ),
    );
  }
}
