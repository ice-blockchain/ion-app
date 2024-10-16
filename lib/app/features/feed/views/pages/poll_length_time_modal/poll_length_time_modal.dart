// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/poll/poll_length_time_provider.dart';
import 'package:ice/app/features/feed/views/pages/poll_length_time_modal/components/poll_picker_item/poll_picker_item.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class PollLengthTimeModal extends ConsumerWidget {
  const PollLengthTimeModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayNotifierProvider);
    final selectedHour = ref.watch(selectedHourNotifierProvider);

    final dayScrollController = FixedExtentScrollController(initialItem: selectedDay);
    final hourScrollController = FixedExtentScrollController(initialItem: selectedHour);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.poll_length_modal_title),
            actions: [
              NavigationCloseButton(
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
          SizedBox(height: 25.0.s),
          PollPickerItem(
            selectedDay: selectedDay,
            selectedHour: selectedHour,
            onDayChanged: (value) => ref.read(selectedDayNotifierProvider.notifier).day = value,
            onHourChanged: (value) => ref.read(selectedHourNotifierProvider.notifier).hour = value,
            dayScrollController: dayScrollController,
            hourScrollController: hourScrollController,
          ),
          SizedBox(height: 25.0.s),
          ScreenSideOffset.large(
            child: Button(
              onPressed: () {
                context.pop();
              },
              mainAxisSize: MainAxisSize.max,
              label: Text(
                context.i18n.button_apply,
                style: context.theme.appTextThemes.body,
              ),
            ),
          ),
          ScreenBottomOffset(
            margin: 5.0.s,
          ),
        ],
      ),
    );
  }
}
