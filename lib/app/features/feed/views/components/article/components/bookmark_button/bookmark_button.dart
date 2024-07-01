import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/bookmarks_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class BookmarkButton extends HookConsumerWidget {
  const BookmarkButton({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkNotifierProvider);
    final isBookmarked = bookmarks.contains(id);

    return IconButton(
      icon: Image.asset(
        isBookmarked
            ? Assets.images.icons.iconBookmarks.path
            : Assets.images.icons.iconBookmarksOn.path,
      ),
      onPressed: () {
        ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(id);
      },
    );
  }
}
