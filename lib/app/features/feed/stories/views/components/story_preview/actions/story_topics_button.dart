// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:ion/app/features/feed/providers/selected_interests_notifier.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryTopicsButton extends HookConsumerWidget {
  const StoryTopicsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableSubcategories = ref.watch(
      feedUserInterestsProvider(FeedType.story)
          .select((state) => state.valueOrNull?.subcategories ?? {}),
    );
    final selectedSubcategoriesKeys = ref.watch(selectedInterestsNotifierProvider);
    final selectedSubcategories =
        selectedSubcategoriesKeys.map((key) => availableSubcategories[key]).nonNulls.toList();

    return ListItem(
      title: Text(
        selectedSubcategories.isEmpty
            ? context.i18n.create_post_add_topic_tooltip_title
            : selectedSubcategories.map((topic) => topic.display).join(', '),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.theme.appColors.secondaryBackground,
      leading: Assets.svg.walletChannelPrivate.icon(
        color: context.theme.appColors.primaryAccent,
        size: 24.s,
      ),
      trailing: Assets.svg.iconArrowRight.icon(
        color: context.theme.appColors.primaryAccent,
        size: 16.s,
      ),
      constraints: BoxConstraints(minHeight: 40.0.s),
      onTap: () {
        SelectTopicsCategoriesRoute(feedType: FeedType.story).push<void>(context);
      },
    );
  }
}
