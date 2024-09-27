import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/schedule_posting_provider.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ScheduleModal extends ConsumerWidget {
  const ScheduleModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedDate = ref.watch(schedulePostingProvider);

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
                selectedDate = newDateTime;
              },
            ),
          ),
        ),
        ScreenSideOffset.large(
          child: Button(
            onPressed: () {
              ref.read(schedulePostingProvider.notifier).selectedDate = selectedDate;
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
