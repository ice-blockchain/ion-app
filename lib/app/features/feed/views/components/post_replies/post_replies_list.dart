// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post_replies/expand_replies_button.dart';
import 'package:ion/app/features/feed/views/components/post_replies/reply_list_item.dart';

class PostRepliesList extends HookWidget {
  const PostRepliesList({required this.replies, super.key});

  final List<PostEntity> replies;

  static double get borderWidth => 3.0.s;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    final expandReplies = useState(false);

    final originalReplies = useMemoized<List<Widget>>(
      () {
        return replies.map((reply) => ReplyListItem(reply: reply)).toList();
      },
      [replies],
    );

    final visibleReplies = expandReplies.value ? originalReplies : originalReplies.take(1);

    if (visibleReplies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: colors.lightBlue,
                width: borderWidth,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: borderWidth),
            child: Column(
              children: visibleReplies.intersperse(FeedListSeparator(height: 1.5.s)).toList(),
            ),
          ),
        ),
        if (originalReplies.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 10.0.s),
            child: ExpandRepliesButton(isExpanded: expandReplies),
          ),
        SizedBox(height: 10.0.s),
      ],
    );
  }
}
