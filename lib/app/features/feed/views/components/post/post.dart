import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_menu.dart';

class Post extends StatefulWidget {
  const Post({
    required this.content,
    required this.isFooterVisible,
    super.key,
  });

  final String content;
  final bool isFooterVisible;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
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
            content: widget.content,
          ),
          if (widget.isFooterVisible) PostFooter(content: widget.content),
        ],
      ),
    );
  }
}
