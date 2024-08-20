import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/components/post_replies/components/expand_replies_button.dart';

class PostReplies extends HookWidget {
  const PostReplies({
    required this.postData,
    super.key,
  });

  final PostData postData;

  static double get borderWidth => 3.0.s;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    final expandReplies = useState(false);

    final originalReplies = <Widget>[
      Post(postData: postData),
      Post(postData: postData),
      Post(postData: postData),
    ];
    final replies = expandReplies.value ? originalReplies : originalReplies.take(1);

    if (replies.isEmpty) {
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
              children: replies.intersperse(FeedListSeparator(height: 1.5.s)).toList(),
            ),
          ),
        ),
        if (originalReplies.length > 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.s),
            child: ExpandRepliesButton(isExpanded: expandReplies),
          ),
      ],
    );
  }
}
