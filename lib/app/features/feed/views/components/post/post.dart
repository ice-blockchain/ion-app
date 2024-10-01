// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/data/models/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_menu/post_menu.dart';

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

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header ?? const PostHeader(trailing: PostMenu()),
          PostBody(postData: postData),
          SizedBox(height: 10.0.s),
          footer ?? PostFooter(postData: postData),
        ],
      ),
    );
  }
}
