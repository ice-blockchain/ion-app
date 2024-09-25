import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/selected_visibility_option_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class VisibilitySettingsToolbar extends ConsumerWidget {
  const VisibilitySettingsToolbar({
    this.trailing,
    super.key,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedVisibilityOptionNotifierProvider);

    return ListItem(
      title: Text(selectedOption != null ? selectedOption.getTitle(context) : '',
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.primaryAccent,
          )),
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.theme.appColors.secondaryBackground,
      leading: selectedOption != null ? selectedOption.getIcon(context) : null,
      trailing: Assets.svg.iconArrowRight.icon(color: context.theme.appColors.primaryAccent),
      constraints: BoxConstraints(minHeight: 40.0.s),
      onTap: () {
        VisibilitySettingsRoute().push<void>(context);
      },
    );
  }
}
