import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/data/model/visibility_settings_options.dart';

class VisibilitySettingsList extends StatelessWidget {
  const VisibilitySettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin,
      ),
      itemCount: VisibilitySettingsOptions.values.length,
      separatorBuilder: (BuildContext context, int index) {
        return const HorizontalSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        final option = VisibilitySettingsOptions.values[index];
        return ListItem(
          title: Text(option.getTitle(context)),
          backgroundColor: context.theme.appColors.secondaryBackground,
          leading: Button.icon(
            onPressed: () {},
            icon: option.getIcon(context),
            size: 36.0.s,
            backgroundColor: context.theme.appColors.tertararyBackground,
            borderColor: context.theme.appColors.onTerararyFill,
            borderRadius: BorderRadius.circular(10.0.s),
          ),
        );
      },
    );
  }
}
