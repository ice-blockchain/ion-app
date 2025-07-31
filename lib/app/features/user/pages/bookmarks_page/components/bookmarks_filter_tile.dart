// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.f.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.r.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarksFilterTile extends ConsumerWidget {
  const BookmarksFilterTile({
    required this.collectionDTag,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final String collectionDTag;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedBookmarksNotifierProvider(collectionDTag: collectionDTag));
    final entity = state.valueOrNull;
    final isLoading = state.isLoading && entity == null;
    final title = collectionDTag == BookmarksSetType.homeFeedCollectionsAll.dTagName
        ? context.i18n.core_all
        : entity?.data.title ?? '';
    if (state.hasError) {
      return const SizedBox();
    }
    final borderColor =
        isActive ? context.theme.appColors.primaryAccent : context.theme.appColors.onTerararyFill;
    final color =
        isActive ? context.theme.appColors.primaryAccent : context.theme.appColors.terararyText;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.0.s,
        padding: EdgeInsets.symmetric(horizontal: 10.0.s),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.theme.appColors.tertararyBackground,
          borderRadius: BorderRadius.circular(12.0.s),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Assets.svg.iconFolderOpen.icon(color: color),
            SizedBox(
              width: 6.0.s,
            ),
            if (isLoading)
              Skeleton(
                child: SizedBox(
                  width: 20.0.s,
                  height: 20.0.s,
                ),
              )
            else
              Text(
                title,
                style: context.theme.appTextThemes.caption.copyWith(
                  color: color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
