// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/selected_visibility_options_provider.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/visibility_settings_modal.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class VisibilitySettingsToolbar extends ConsumerWidget {
  const VisibilitySettingsToolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedVisibilityOptionsProvider);

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
          child: const VisibilitySettingsModal(),
        );
      },
    );
  }
}
