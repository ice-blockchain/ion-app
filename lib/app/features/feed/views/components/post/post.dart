import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_menu.dart';
import 'package:ice/app/router/app_routes.dart';

class Post extends StatefulWidget {
  const Post({
    required this.content,
    super.key,
  });

  final String content;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isCommentActive = false;
  bool isReposted = false;
  bool isLiked = false;

  void toggleComment() {
    setState(() {
      isCommentActive = !isCommentActive;
    });
  }

  void toggleRepost() {
    IceRoutes.shareType.push(context, payload: widget.content);
    setState(() {
      isReposted = !isReposted;
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

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
          PostFooter(
            content: widget.content,
            isCommentActive: isCommentActive,
            isReposted: isReposted,
            isLiked: isLiked,
            onToggleComment: toggleComment,
            onToggleRepost: toggleRepost,
            onToggleLike: toggleLike,
            onShareOptions: () {},
            onIceStroke: () {},
          ),
        ],
      ),
    );
  }
}
