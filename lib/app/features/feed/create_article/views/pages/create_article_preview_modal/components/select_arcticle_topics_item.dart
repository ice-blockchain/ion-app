// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/views/pages/topic_select_modal/topic_select_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectArticleTopicsItem extends ConsumerWidget {
  const SelectArticleTopicsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.medium(
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
          child: Assets.svg.walletChannelPrivate.icon(color: context.theme.appColors.primaryAccent),
        ),
        trailing: Assets.svg.iconArrowRight.icon(color: context.theme.appColors.primaryText),
        constraints: BoxConstraints(minHeight: 40.0.s),
        onTap: () {
          showSimpleBottomSheet<void>(
            context: context,
            child: const TopicSelectModal(selectedTopics: []),
          );
        },
      ),
    );
  }
}
