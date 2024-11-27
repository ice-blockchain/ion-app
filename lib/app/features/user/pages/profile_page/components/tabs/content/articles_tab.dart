// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/post_list_item.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content_separator.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';

class ArticlesTab extends StatelessWidget {
  const ArticlesTab({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  static const UserContentType tabType = UserContentType.articles;

  @override
  Widget build(BuildContext context) {
    const articles = <PostEntity>[];

    if (articles.isEmpty) {
      return const EmptyState();
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        return ColoredBox(
          color: context.theme.appColors.secondaryBackground,
          child: PostListItem(
            post: articles[index],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const ContentSeparator();
      },
      itemCount: articles.length,
    );
  }
}
