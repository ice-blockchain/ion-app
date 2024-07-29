import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_menu.dart';
import 'package:ice/app/features/feed/views/components/post_replies/post_replies.dart';
import 'package:ice/app/router/app_routes.dart';

class Post extends StatelessWidget {
  const Post({
    required this.postData,
    this.canShowReplies = true,
    this.footer,
    super.key,
  });

  final PostData postData;
  final bool canShowReplies;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PostDetailsRoute($extra: postData.id).push<void>(context),
      child: ScreenSideOffset.small(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PostHeader(
              trailing: PostMenu(),
            ),
            PostBody(postData: postData),
            SizedBox(height: 10.0.s),
            footer ?? PostFooter(postData: postData),
            if (canShowReplies) PostReplies(postData: postData),
          ],
        ),
      ),
    );
  }
}
