// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarkFooterButton extends ConsumerWidget {
  const BookmarkFooterButton({
    required this.eventReference,
    required this.type,
    super.key,
  });

  final EventReference? eventReference;
  final BookmarksSetType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (eventReference == null) {
      return const SizedBox.shrink();
    }

    final isBookmarked = ref.watch(isBookmarkedProvider(eventReference!)).value ?? false;
    return IconButton(
      icon: SvgPicture.asset(
        isBookmarked ? Assets.svg.iconBookmarksOn : Assets.svg.iconBookmarks,
        width: 16.0.s,
        height: 16.0.s,
        colorFilter: isBookmarked
            ? null
            : ColorFilter.mode(context.theme.appColors.onTertararyBackground, BlendMode.srcIn),
      ),
      onPressed: () => ref.read(bookmarksNotifierProvider.notifier).toggleBookmark(
            eventReference!,
            type: type,
          ),
    );
  }
}
