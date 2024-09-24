import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/selected_visibility_option_provider.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/data/model/visibility_settings_options.dart';
import 'package:ice/generated/assets.gen.dart';

class VisibilitySettingsListItem extends ConsumerWidget {
  const VisibilitySettingsListItem({
    required this.option,
    required this.isSelected,
    super.key,
  });

  final VisibilitySettingsOptions option;
  final bool isSelected;

  void selectOption(BuildContext context, WidgetRef ref) {
    ref.read(selectedVisibilityOptionNotifierProvider.notifier).selectedOption = option;
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListItem(
      onTap: () => selectOption(context, ref),
      title: Text(option.getTitle(context)),
      backgroundColor: context.theme.appColors.secondaryBackground,
      leading: Button.icon(
        onPressed: () => selectOption(context, ref),
        icon: option.getIcon(context),
        size: 36.0.s,
        backgroundColor: context.theme.appColors.tertararyBackground,
        borderColor: context.theme.appColors.onTerararyFill,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      trailing: isSelected
          ? Assets.svg.iconBlockCheckboxOn.icon()
          : Assets.svg.iconBlockCheckboxOff.icon(),
    );
  }
}
