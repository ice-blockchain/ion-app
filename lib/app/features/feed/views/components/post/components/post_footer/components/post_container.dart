import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0.s, top: 16.0.s),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.theme.appColors.onTerararyFill),
          borderRadius: BorderRadius.circular(16.0.s),
        ),
        child: Column(
          children: [
            const PostHeader(),
            PostBody(content: content),
            SizedBox(height: 16.0.s),
          ],
        ),
      ),
    );
  }
}
