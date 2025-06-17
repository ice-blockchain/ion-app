// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarkButton extends HookConsumerWidget {
  const BookmarkButton({
    required this.eventReference,
    this.size,
    this.color,
    super.key,
  });

  final EventReference eventReference;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkState = ref.watch(feedBookmarksNotifierProvider());
    final isLoading = bookmarkState.isLoading;
    final isBookmarked = ref.watch(isBookmarkedInCollectionProvider(eventReference));

    useEffect(
      () {
        // sync to DB if bookmarked from cache only
        if (isBookmarked) {
          ref.read(ionConnectDbCacheProvider.notifier).saveRef(eventReference, network: false);
        }
        return null;
      },
      [isBookmarked],
    );

    ref.displayErrors(feedBookmarksNotifierProvider());

    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              ref.read(feedBookmarksNotifierProvider().notifier).toggleBookmark(eventReference);
              if (!isBookmarked) {
                AddBookmarkRoute(eventReference: eventReference.encode()).push<void>(context);
              }
            },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 8.0.s) +
            EdgeInsetsDirectional.only(bottom: 1.0.s),
        child: Center(
          child: TextActionButton(
            icon: isBookmarked
                ? IconAsset(Assets.svgIconBookmarksOn, size: size)
                : IconAssetColored(Assets.svgIconBookmarks, size: size, color: color ?? Colors.black),
            textColor: color ?? context.theme.appColors.onTertararyBackground,
          ),
        ),
      ),
    );
  }
}
