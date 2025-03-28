// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/num.dart';

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 10.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.0.s),
          const ListItemUserShape(),
          SizedBox(height: 10.0.s),
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
