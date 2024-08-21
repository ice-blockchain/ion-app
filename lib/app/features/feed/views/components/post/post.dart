import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_menu/post_menu.dart';
import 'package:ice/app/router/app_routes.dart';

class Post extends StatelessWidget {
  const Post({
    required this.postData,
    this.header,
    this.footer,
    super.key,
  });

  final PostData postData;
  final Widget? header;
  final Widget? footer;

  void _openPostDetails(BuildContext context) {
    if (!GoRouterState.of(context).pathParameters.containsValue(postData.id)) {
      PostDetailsRoute(postId: postData.id).push<void>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPostDetails(context),
      child: ScreenSideOffset.small(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header ?? const PostHeader(trailing: PostMenu()),
            PostBody(postData: postData),
            SizedBox(height: 10.0.s),
            footer ?? PostFooter(postData: postData),
          ],
        ),
      ),
    );
  }
}
