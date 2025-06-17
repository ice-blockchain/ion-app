// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/showcase/showcase_wrapper.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/views/components/topics/topics_button_tooltip.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.c.dart';
import 'package:ion/app/features/feed/providers/selected_interests_notifier.c.dart';
import 'package:ion/app/features/feed/providers/topic_tooltip_visibility_notifier.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:showcaseview/showcaseview.dart';

class TopicsButton extends HookConsumerWidget {
  const TopicsButton({
    required this.type,
    super.key,
  });

  final FeedType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsButtonKey = useRef(GlobalKey());
    final topicsTooltipVisible =
        ref.watch(topicTooltipVisibilityNotifierProvider).valueOrNull.falseOrValue;
    final availableCategories =
        ref.watch(feedUserInterestsProvider(type)).valueOrNull?.categories ?? {};
    final selectedSubcategoriesKeys = ref.watch(selectedInterestsNotifierProvider);
    final selectedSubcategories = selectedSubcategoriesKeys
        .map(
          (key) => availableCategories.values
              .expand((category) => category.children.entries)
              .firstWhereOrNull((subcategoryEntry) => subcategoryEntry.key == key)
              ?.value,
        )
        .nonNulls
        .toList();

    useOnInit(
      () {
        if (!topicsTooltipVisible) return;
        Future<void>.delayed(const Duration(milliseconds: 250)).then((_) {
          if (!context.mounted) return;
          ShowCaseWidget.of(context).startShowCase(
            [topicsButtonKey.value],
          );
        });
      },
      [topicsTooltipVisible],
    );

    return ShowcaseWrapper(
      showcaseKey: topicsButtonKey.value,
      tooltipWidth: 295.s,
      tooltipBuilder: (context, arrow) => TopicsButtonTooltip(
        arrow: arrow,
      ),
      targetBorderRadius: BorderRadius.circular(14.s),
      onDismissed: () {
        ref.read(topicTooltipVisibilityNotifierProvider.notifier).markAsSeen();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          SelectTopicsCategoriesRoute(feedType: type).push<void>(context);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0.s),
            color: context.theme.appColors.primaryBackground,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.s, horizontal: 6.s),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconAssetColored(
                  Assets.svgWalletChannelPrivate,
                  color: context.theme.appColors.primaryAccent,
                  size: 16.0,
                ),
                SizedBox(width: 2.s),
                Flexible(
                  child: Text(
                    selectedSubcategories.isEmpty
                        ? context.i18n.create_post_add_topic
                        : selectedSubcategories.map((topic) => topic.display).join(', '),
                    style: context.theme.appTextThemes.caption2.copyWith(
                      color: context.theme.appColors.primaryAccent,
                    ),
                    textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                  ),
                ),
                SizedBox(width: 2.s),
                IconAssetColored(
                  Assets.svgIconArrowRight,
                  color: context.theme.appColors.primaryAccent,
                  size: 14.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
