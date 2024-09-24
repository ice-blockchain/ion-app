import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/data/model/visibility_settings_options.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class VisibilitySettingsToolbar extends StatelessWidget {
  const VisibilitySettingsToolbar({
    this.trailing,
    super.key,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final option = VisibilitySettingsOptions.values[0];

    return ListItem(
      title: Text(
        option.getTitle(context),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.theme.appColors.secondaryBackground,
      leading: option.getIcon(context),
      trailing: Assets.svg.iconArrowRight.icon(color: context.theme.appColors.primaryAccent),
      constraints: BoxConstraints(minHeight: 40.0.s),
      onTap: () {
        VisibilitySettingsRoute().go(context);
      },
    );
  }
}
