import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ScheduleModal extends StatelessWidget {
  const ScheduleModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          title: Text(context.i18n.schedule_modal_nav_title),
          actions: [NavigationCloseButton(onPressed: context.pop)],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 26.0.s),
          child: SizedBox(
            height: 178.0.s,
            child: CupertinoDatePicker(
              initialDateTime: date,
              use24hFormat: true,
              onDateTimeChanged: (DateTime newDateTime) {},
            ),
          ),
        ),
        ScreenSideOffset.large(
          child: Button(
            onPressed: () => {},
            mainAxisSize: MainAxisSize.max,
            label: Text(
              context.i18n.button_schedule,
              style: context.theme.appTextThemes.body,
            ),
          ),
        ),
      ],
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       NavigationAppBar.modal(
//         showBackButton: false,
//         title: Text(context.i18n.visibility_settings_title_video),
//       ),
//       SizedBox(height: 12.0.s),
//       const HorizontalSeparator(),
//       const VisibilitySettingsList(),
//       const HorizontalSeparator(),
//       ScreenBottomOffset(
//         margin: 36.0.s,
//       ),
//     ],
//   );
// }
