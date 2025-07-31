// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/articles_carousel_item.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

class ArticlesCarousel extends ConsumerWidget {
  const ArticlesCarousel({
    required this.articlesReferences,
    super.key,
  });

  final List<EventReference> articlesReferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 161.0.s,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
          itemCount: articlesReferences.length,
          separatorBuilder: (context, index) => SizedBox(width: 16.0.s),
          itemBuilder: (context, index) => Container(
            width: 310.0.s,
            decoration: BoxDecoration(
              color: context.theme.appColors.onPrimaryAccent,
              borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
              border: Border.all(
                width: 1.0.s,
                color: context.theme.appColors.onTertararyFill,
              ),
            ),
            padding: EdgeInsets.all(12.0.s),
            child: ArticlesCarouselItem(eventReference: articlesReferences[index]),
          ),
        ),
      ),
    );
  }
}
