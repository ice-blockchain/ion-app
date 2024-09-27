import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ScheduleModal extends StatelessWidget {
  const ScheduleModal({
    required this.onDateScheduled,
    required this.selectedDate,
    super.key,
  });

  final ValueChanged<DateTime> onDateScheduled;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          title: Text(context.i18n.schedule_modal_nav_title),
          actions: [NavigationCloseButton(onPressed: context.pop)],
          onBackPress: context.pop,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 26.0.s),
          child: SizedBox(
            height: 178.0.s,
            child: CupertinoDatePicker(
              initialDateTime: selectedDate,
              use24hFormat: true,
              onDateTimeChanged: (DateTime newDateTime) {
                onDateScheduled(newDateTime);
                context.pop();
              },
            ),
          ),
        ),
        ScreenSideOffset.large(
          child: Button(
            onPressed: () {
              onDateScheduled.call(selectedDate);
              context.pop();
            },
            mainAxisSize: MainAxisSize.max,
            label: Text(
              context.i18n.button_schedule,
              style: context.theme.appTextThemes.body,
            ),
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
