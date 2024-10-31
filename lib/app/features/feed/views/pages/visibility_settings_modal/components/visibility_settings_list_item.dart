// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/visibility_settings_options.dart';
import 'package:ion/app/features/feed/providers/selected_visibility_options_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class VisibilitySettingsListItem extends ConsumerWidget {
  const VisibilitySettingsListItem({
    required this.option,
    super.key,
  });

  final VisibilitySettingsOptions option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedVisibilityOptionsProvider);
    final isSelected = selectedOption == option;

    return ListItem(
      onTap: () => ref.read(selectedVisibilityOptionsProvider.notifier).selectedOption = option,
      title: Text(option.getTitle(context)),
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
        child: option.getIcon(context),
      ),
      trailing: GestureDetector(
        onTap: () => ref.read(selectedVisibilityOptionsProvider.notifier).selectedOption = option,
        child: isSelected
            ? Assets.svg.iconBlockCheckboxOn.icon()
            : Assets.svg.iconBlockCheckboxOff.icon(),
      ),
    );
  }
}
