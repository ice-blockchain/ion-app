import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/extensions.dart';

class QuotePostCommentInput extends StatelessWidget {
  const QuotePostCommentInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.0.s),
          child: Avatar(
            size: 30.0.s,
            imageUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          ),
        ),
        SizedBox(width: 10.0.s),
        Expanded(
          child: TextField(
            maxLines: null,
            style: context.theme.appTextThemes.body2,
            decoration: InputDecoration(
              hintStyle: context.theme.appTextThemes.body2,
              hintText: context.i18n.feed_comment_hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
