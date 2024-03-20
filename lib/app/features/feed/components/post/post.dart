import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/components/post/components/post_header/post_menu.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const PostHeader(
            trailing: PostMenu(),
          ),
          PostBody(
            content: content,
          ),
          const PostFooter(),
        ],
      ),
    );
  }
}
