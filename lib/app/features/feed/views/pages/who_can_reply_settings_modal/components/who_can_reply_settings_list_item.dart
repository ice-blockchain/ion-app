// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.f.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.r.dart';
import 'package:ion/generated/assets.gen.dart';

class WhoCanReplySettingsListItem extends ConsumerWidget {
  const WhoCanReplySettingsListItem({
    required this.option,
    super.key,
  });

  final WhoCanReplySettingsOption option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedWhoCanReplyOptionProvider);
    final isSelected = selectedOption == option;

    void onSelect() {
      ref.read(selectedWhoCanReplyOptionProvider.notifier).option = option;
      Navigator.pop(context, false);
    }

    return ListItem(
      onTap: onSelect,
      title: Text(option.getTitle(context)),
      backgroundColor: context.theme.appColors.secondaryBackground,
      leading: Container(
        width: 36.0.s,
        height: 36.0.s,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.theme.appColors.terararyBackground,
          borderRadius: BorderRadius.all(Radius.circular(10.0.s)),
          border: Border.all(
            width: 1.0.s,
            color: context.theme.appColors.onTerararyFill,
          ),
        ),
        child: option.getIcon(context),
      ),
      trailing: GestureDetector(
        onTap: onSelect,
        child: isSelected
            ? Assets.svg.iconBlockCheckboxOn.icon()
            : Assets.svg.iconBlockCheckboxOff.icon(),
      ),
    );
  }
}
