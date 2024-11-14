// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/articles_carousel_item.dart';

class ArticlesCarousel extends ConsumerWidget {
  const ArticlesCarousel({
    this.articleIds,
    super.key,
  });

  final List<String>? articleIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (articleIds == null || articleIds!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 161.0.s,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
          itemCount: articleIds!.length,
          separatorBuilder: (context, index) => SizedBox(width: 16.0.s),
          itemBuilder: (context, index) => Container(
            width: MediaQuery.sizeOf(context).width * 0.83,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: context.theme.appColors.onPrimaryAccent,
              borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
              border: Border.all(
                width: 1.0.s,
                color: context.theme.appColors.onTerararyFill,
              ),
            ),
            padding: EdgeInsets.all(
              12.0.s,
            ),
            child: ArticlesCarouselItem(articleId: articleIds![index]),
          ),
        ),
      ),
    );
  }
}
