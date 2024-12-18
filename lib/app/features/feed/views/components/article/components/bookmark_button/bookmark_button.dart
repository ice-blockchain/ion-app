// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton.post({required this.id, super.key}) : type = BookmarksSetType.posts;

  const BookmarkButton.story({required this.id, super.key}) : type = BookmarksSetType.stories;

  const BookmarkButton.video({required this.id, super.key}) : type = BookmarksSetType.videos;

  const BookmarkButton.article({required this.id, super.key}) : type = BookmarksSetType.articles;

  final String? id;
  final BookmarksSetType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null || id!.isEmpty) {
      return const SizedBox.shrink();
    }
    final isBookmarked = ref.watch(isBookmarkedProvider(id, type: type));

    return IconButton(
      icon: SvgPicture.asset(
        isBookmarked ? Assets.svg.iconBookmarksOn : Assets.svg.iconBookmarks,
      ),
      onPressed: () {
        ref.read(bookmarksNotifierProvider.notifier).toggleBookmark(id, type: type);
      },
    );
  }
}
