// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({
    required this.eventReference,
    this.iconSize,
    this.colorFilter,
    super.key,
  });

  final EventReference? eventReference;
  final double? iconSize;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (eventReference == null) {
      return const SizedBox.shrink();
    }

    final isBookmarked = ref.watch(isBookmarkedProvider(eventReference!)).value ?? false;

    return IconButton(
      icon: SvgPicture.asset(
        isBookmarked ? Assets.svg.iconBookmarksOn : Assets.svg.iconBookmarks,
        width: iconSize,
        height: iconSize,
        colorFilter: isBookmarked ? null : colorFilter,
      ),
      onPressed: () => ref.read(bookmarksNotifierProvider.notifier).toggleBookmark(
            eventReference!,
          ),
    );
  }
}
