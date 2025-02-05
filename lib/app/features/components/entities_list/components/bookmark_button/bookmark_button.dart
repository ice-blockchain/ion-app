// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({
    required this.eventReference,
    super.key,
  });

  final EventReference? eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (eventReference == null) {
      return const SizedBox.shrink();
    }

    final isBookmarked = ref.watch(isBookmarkedProvider(eventReference!)).value ?? false;

    ref.displayErrors(bookmarksNotifierProvider);

    final color = context.theme.appColors.onTertararyBackground;
    return GestureDetector(
      onTap: () => ref.read(bookmarksNotifierProvider.notifier).toggleBookmark(eventReference!),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 8.0.s) +
            EdgeInsetsDirectional.only(bottom: 1.0.s),
        child: Center(
          child: TextActionButton(
            icon: isBookmarked
                ? Assets.svg.iconBookmarksOn.icon(size: 16.0.s)
                : Assets.svg.iconBookmarks.icon(size: 16.0.s, color: color),
            textColor: color,
          ),
        ),
      ),
    );
  }
}
