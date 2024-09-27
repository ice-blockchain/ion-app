import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/pages/schedule_modal/schedule_modal.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorScheduleButton extends StatelessWidget {
  const TextEditorScheduleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconCreatepostShedule,
      onPressed: () {
        showSimpleBottomSheet<void>(
          context: context,
          child: const ScheduleModal(),
        );
      },
    );
  }
}
