// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/num.dart';

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 10.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.0.s),
          ListItemUserShape(color: color),
          SizedBox(height: 10.0.s),
          _PostSkeletonText(widthFactor: 0.8, color: color),
          _PostSkeletonText(color: color),
          _PostSkeletonText(color: color),
          _PostSkeletonText(widthFactor: 0.4, color: color),
        ],
      ),
    );
  }
}

class _PostSkeletonText extends StatelessWidget {
  const _PostSkeletonText({
    this.widthFactor = 1,
    this.color,
  });

  final Color? color;
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
            color: color ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
