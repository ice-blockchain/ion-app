// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/article/select_topics_provider.c.dart';
import 'package:ion/app/features/feed/views/components/topics_carousel/topics_carousel.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectArticleTopicsItem extends ConsumerWidget {
  const SelectArticleTopicsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopics = ref.watch(selectTopicsProvider);

    return Column(
      children: [
        ScreenSideOffset.medium(
          child: ListItem(
            title: Text(
              context.i18n.topics_title,
              style: context.theme.appTextThemes.body.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: context.theme.appColors.secondaryBackground,
            leading: Container(
              width: 36.0.s,
              height: 36.0.s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.theme.appColors.tertararyBackground,
                borderRadius: BorderRadius.all(Radius.circular(10.0.s)),
                border: Border.all(
                  width: 1.0.s,
                  color: context.theme.appColors.onTerararyFill,
                ),
              ),
              child: Assets.svg.walletChannelPrivate
                  .icon(color: context.theme.appColors.primaryAccent),
            ),
            trailing: Assets.svg.iconArrowRight.icon(color: context.theme.appColors.primaryText),
            constraints: BoxConstraints(minHeight: 40.0.s),
            onTap: () {
              SelectArticleTopicsRoute().push<void>(ref.context);
            },
          ),
        ),
        if (selectedTopics.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.only(top: 10.0.s),
            child: TopicsCarousel(topics: selectedTopics),
          ),
      ],
    );
  }
}
