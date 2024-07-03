import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_menu.dart';

class Post extends StatelessWidget {
  const Post({
    required this.postData,
    this.footer,
    super.key,
  });

  final PostData postData;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final footerDefault = PostFooter(postData: postData);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const PostHeader(
            trailing: PostMenu(),
          ),
          PostBody(
            content: postData.body,
          ),
          footer ?? footerDefault,
        ],
      ),
    );
  }
}
