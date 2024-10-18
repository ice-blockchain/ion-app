// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_footer/post_details_action_button.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_footer/post_footer.dart';

class PostDetailsFooter extends StatelessWidget {
  const PostDetailsFooter({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    const postDate = '9:34  20.06.2023';
    final colors = context.theme.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          postDate,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: colors.quaternaryText,
          ),
        ),
        SizedBox(height: 12.0.s),
        PostFooter(
          postData: postData,
          bottomPadding: 12.0.s,
          actionBuilder: (context, child, onPressed) => PostDetailsActionButton(
            onPressed: onPressed,
            child: child,
          ),
        ),
      ],
    );
  }
}
