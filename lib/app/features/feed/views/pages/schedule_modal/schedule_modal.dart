import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
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
        SizedBox(height: 12.0.s),
        SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            initialDateTime: date,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDateTime) {},
          ),
        ),
        ScreenBottomOffset(
          margin: 36.0.s,
        ),
      ],
    );
  }
}
