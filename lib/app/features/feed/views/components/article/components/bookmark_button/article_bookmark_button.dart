// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';

class ArticleBookmarkButton extends ConsumerWidget {
  const ArticleBookmarkButton({required this.article, super.key});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isArticleBookmarkedProvider(article));

    return BookmarkButton(
      isBookmarked: isBookmarked,
      onBookmark: () {
        ref.read(bookmarksNotifierProvider.notifier).toggleArticleBookmark(article);
      },
    );
  }
}
