import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/bookmarks_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class BookmarkButton extends HookConsumerWidget {
  const BookmarkButton({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> bookmarks = ref.watch(bookmarkNotifierProvider);
    final bool isBookmarked = bookmarks.contains(id);

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
