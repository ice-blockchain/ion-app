// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.f.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.r.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_settings_modal/who_can_reply_settings_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectArticleWhoCanReplyItem extends ConsumerWidget {
  const SelectArticleWhoCanReplyItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedWhoCanReplyOptionProvider);

    return ScreenSideOffset.medium(
      child: ListItem(
        title: Text(
          selectedOption.getTitle(context),
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
              color: context.theme.appColors.onTertararyFill,
            ),
          ),
          child: selectedOption.getIcon(context),
        ),
        trailing: Assets.svg.iconArrowRight.icon(color: context.theme.appColors.primaryText),
        constraints: BoxConstraints(minHeight: 40.0.s),
        onTap: () {
          showSimpleBottomSheet<void>(
            context: context,
            child:
                WhoCanReplySettingsModal(title: context.i18n.who_can_reply_settings_title_article),
          );
        },
      ),
    );
  }
}
