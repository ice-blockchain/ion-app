import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ScheduleModal extends ConsumerStatefulWidget {
  const ScheduleModal({
    required this.initialDate,
    super.key,
  });

  final DateTime initialDate;

  @override
  ConsumerState<ScheduleModal> createState() => _ScheduleModalState();
}

class _ScheduleModalState extends ConsumerState<ScheduleModal> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          title: Text(context.i18n.schedule_modal_nav_title),
          actions: [NavigationCloseButton(onPressed: () => context.pop())],
          onBackPress: () => context.pop(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 26.0.s),
          child: SizedBox(
            height: 178.0.s,
            child: CupertinoDatePicker(
              initialDateTime: _selectedDate,
              use24hFormat: true,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _selectedDate = newDateTime;
                });
              },
            ),
          ),
        ),
        ScreenSideOffset.large(
          child: Button(
            onPressed: () {
              context.pop(_selectedDate);
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
