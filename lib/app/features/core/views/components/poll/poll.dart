// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/poll/poll_length_time_provider.c.dart';
import 'package:ion/app/features/core/views/components/poll/poll_add_answer_button.dart';
import 'package:ion/app/features/core/views/components/poll/poll_answers_list_view.dart';
import 'package:ion/app/features/core/views/components/poll/poll_close_button.dart';
import 'package:ion/app/features/core/views/components/poll/poll_length_button.dart';
import 'package:ion/app/features/feed/views/pages/poll_length_time_modal/poll_length_time_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class Poll extends ConsumerWidget {
  const Poll({
    super.key,
    this.onRemove,
  });

  final VoidCallback? onRemove;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final selectedDay = ref.watch(selectedDayNotifierProvider);
    final selectedHour = ref.watch(selectedHourNotifierProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.appColors.onPrimaryAccent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.theme.appColors.onTerararyFill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0.s),
                child: const Column(
                  children: [
                    PollAnswersListView(),
                    PollAddAnswerButton(),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PollLengthButton(
                  onPollLengthPress: () {
                    _showPollLengthTimeModal(
                      context,
                      selectedDay,
                      selectedHour,
                      (newDay, newHour) {
                        ref.read(selectedDayNotifierProvider.notifier).day = newDay;
                        ref.read(selectedHourNotifierProvider.notifier).hour = newHour;
                      },
                    );
                  },
                ),
                Text(
                  getFormattedPollLength(context, selectedDay, selectedHour),
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (onRemove != null)
          PollCloseButton(
            onClosePress: onRemove!,
          ),
      ],
    );
  }

  Future<void> _showPollLengthTimeModal(
    BuildContext context,
    int selectedDay,
    int selectedHour,
    void Function(int, int) onApply,
  ) async {
    return showSimpleBottomSheet<void>(
      context: context,
      child: PollLengthTimeModal(
        selectedDay: selectedDay,
        selectedHour: selectedHour,
        onApply: onApply,
      ),
    );
  }
}

String getFormattedPollLength(BuildContext context, int days, int hours) {
  if (days > 0 && hours > 0) {
    return '$days ${Intl.plural(
      days,
      one: context.i18n.day(1),
      other: context.i18n.day(days),
    )} $hours ${Intl.plural(
      hours,
      one: context.i18n.hour(1),
      other: context.i18n.hour(hours),
    )}';
  } else if (days > 0) {
    return '$days ${Intl.plural(
      days,
      one: context.i18n.day(1),
      other: context.i18n.day(days),
    )}';
  } else if (hours > 0) {
    return '$hours ${Intl.plural(
      hours,
      one: context.i18n.hour(1),
      other: context.i18n.hour(hours),
    )}';
  }

  return '';
}
