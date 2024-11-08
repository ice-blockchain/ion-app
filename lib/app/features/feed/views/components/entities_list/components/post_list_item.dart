// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/router/app_routes.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({required this.post, super.key});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: post.id).push<void>(context),
      child: Post(postEntity: post),
    );
  }
}
