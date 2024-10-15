// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/poll_length_time_modal/components/poll_picker_item/poll_picker_item.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class PollLengthTimeModal extends HookWidget {
  const PollLengthTimeModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDay = useState(1);
    final selectedHour = useState(0);

    final dayScrollController = FixedExtentScrollController(initialItem: selectedDay.value);
    final hourScrollController = FixedExtentScrollController(initialItem: selectedHour.value);

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
          Stack(
            children: [
              Positioned.fill(
                child: Align(
                  child: Container(
                    height: 34.0.s,
                    margin: EdgeInsets.symmetric(horizontal: 9.0.s),
                    decoration: BoxDecoration(
                      color: context.theme.appColors.onSecondaryBackground,
                      borderRadius: BorderRadius.circular(8.0.s),
                    ),
                  ),
                ),
              ),
              PollPickerItem(
                selectedDay: selectedDay.value,
                selectedHour: selectedHour.value,
                onDayChanged: (value) => selectedDay.value = value,
                onHourChanged: (value) => selectedHour.value = value,
                dayScrollController: dayScrollController,
                hourScrollController: hourScrollController,
              ),
            ],
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
