// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/poll_length_time_modal/components/poll_picker_column/poll_picker_column.dart';

const maxDaysCount = 8;
const maxHoursCount = 24;

class PollPickerItem extends StatelessWidget {
  const PollPickerItem({
    required this.selectedDay,
    required this.selectedHour,
    required this.onDayChanged,
    required this.onHourChanged,
    required this.dayScrollController,
    required this.hourScrollController,
    super.key,
  });

  final int selectedDay;
  final int selectedHour;
  final ValueChanged<int> onDayChanged;
  final ValueChanged<int> onHourChanged;
  final FixedExtentScrollController dayScrollController;
  final FixedExtentScrollController hourScrollController;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        Row(
          children: [
            SizedBox(width: 45.0.s),
            Flexible(
              child: PollPickerColumn(
                maxCount: maxDaysCount,
                alignment: MainAxisAlignment.end,
                controller: dayScrollController,
                selectedValue: ValueNotifier<int>(selectedDay),
                labelBuilder: (value) => Intl.plural(
                  value,
                  one: context.i18n.day(1),
                  other: context.i18n.day(value),
                ),
                onSelectedItemChanged: onDayChanged,
              ),
            ),
            SizedBox(width: 5.0.s),
            Flexible(
              child: PollPickerColumn(
                maxCount: maxHoursCount,
                controller: hourScrollController,
                selectedValue: ValueNotifier<int>(selectedHour),
                labelBuilder: (value) => Intl.plural(
                  value,
                  one: context.i18n.hour(1),
                  other: context.i18n.hour(value),
                ),
                onSelectedItemChanged: onHourChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
