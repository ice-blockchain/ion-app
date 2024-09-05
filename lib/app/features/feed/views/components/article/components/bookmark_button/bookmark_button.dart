import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/bookmarks_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkNotifierProvider);
    final isBookmarked = bookmarks.contains(id);

    return IconButton(
      icon: SvgPicture.asset(
        isBookmarked ? Assets.images.icons.iconBookmarks : Assets.images.icons.iconBookmarksOn,
      ),
      onPressed: () {
        ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(id);
      },
    );
  }
}
