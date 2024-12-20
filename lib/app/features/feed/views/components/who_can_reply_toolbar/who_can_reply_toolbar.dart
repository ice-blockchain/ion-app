// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_settings_modal/who_can_reply_settings_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class WhoCanReplyToolbar extends ConsumerWidget {
  const WhoCanReplyToolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedWhoCanReplyOptionProvider);

    return ListItem(
      title: Text(
        selectedOption.getTitle(context),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.theme.appColors.secondaryBackground,
      leading: selectedOption.getIcon(context),
      trailing: Assets.svg.iconArrowRight.icon(color: context.theme.appColors.primaryAccent),
      constraints: BoxConstraints(minHeight: 40.0.s),
      onTap: () {
        showSimpleBottomSheet<void>(
          context: context,
          child: const WhoCanReplySettingsModal(),
        );
      },
    );
  }
}
