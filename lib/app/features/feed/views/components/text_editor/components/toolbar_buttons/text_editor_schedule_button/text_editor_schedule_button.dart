import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/schedule_posting_provider.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/pages/schedule_modal/schedule_modal.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorScheduleButton extends ConsumerWidget {
  const TextEditorScheduleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(schedulePostingProvider);

    return ActionsToolbarButton(
      icon: Assets.svg.iconCreatepostShedule,
      onPressed: () async {
        final selectedDate = await showSimpleBottomSheet<DateTime>(
          context: context,
          child: ScheduleModal(
            initialDate: date,
          ),
        );

        if (selectedDate != null) {
          ref.read(schedulePostingProvider.notifier).selectedDate = selectedDate;
        }
      },
    );
  }
}
