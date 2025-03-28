// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';

class TopicsCarousel extends ConsumerWidget {
  const TopicsCarousel({
    this.topics,
    this.padding,
    super.key,
  });

  final List<ArticleTopic>? topics;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (topics == null || topics!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 30.0.s,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultMediumMargin),
          itemCount: topics!.length,
          separatorBuilder: (context, index) => SizedBox(width: 12.0.s),
          itemBuilder: (context, index) => Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.theme.appColors.secondaryBackground,
              borderRadius: BorderRadius.all(Radius.circular(10.0.s)),
              border: Border.all(
                width: 1.0.s,
                color: context.theme.appColors.onTerararyFill,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8.0.s,
            ),
            child: Text(
              topics![index].getTitle(context),
              style: context.theme.appTextThemes.caption2.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
