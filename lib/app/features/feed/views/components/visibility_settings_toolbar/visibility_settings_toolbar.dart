import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/data/model/visibility_settings_options.dart';
import 'package:ice/app/router/app_routes.dart';

class VisibilitySettingsToolbar extends StatelessWidget {
  const VisibilitySettingsToolbar({
    this.trailing,
    super.key,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final option = VisibilitySettingsOptions.values[0];

    return SizedBox(
      height: 40.0.s,
      child: ListItem(
        title: Text(option.getTitle(context)),
        backgroundColor: context.theme.appColors.onSecondaryBackground,
        leading: option.getIcon(context),
        onTap: () {
          VisibilitySettingsRoute().go(context);
        },
      ),
    );
  }
}
