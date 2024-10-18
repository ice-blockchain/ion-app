// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class QuotePostCommentInput extends HookWidget {
  const QuotePostCommentInput({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    useOnInit(focusNode.requestFocus);

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
            focusNode: focusNode,
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
