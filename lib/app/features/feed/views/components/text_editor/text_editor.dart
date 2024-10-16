// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/poll/poll_length_time_provider.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/text_editor_poll_block.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ice/app/features/feed/views/pages/poll_length_time_modal/poll_length_time_modal.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';

class TextEditor extends ConsumerWidget {
  const TextEditor(
    this.controller, {
    super.key,
    this.placeholder,
  });
  final QuillController controller;
  final String? placeholder;

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
        onApply: (newDay, newHour) {
          onApply(newDay, newHour);
        },
      ),
    );
  }

  void _removePoll(Embed node) {
    final delta = controller.document.toDelta();
    var pollIndex = -1;
    var pollLength = 0;
    var currentIndex = 0;

    for (final operation in delta.operations) {
      final length = operation.length ?? 1;

      if (operation.isInsert && operation.data is Map<String, dynamic>) {
        final data = operation.data! as Map<String, dynamic>;
        if (data.containsKey('custom')) {
          pollIndex = currentIndex;
          pollLength = length;
          break;
        }
      }
      currentIndex += length;
    }

    if (pollIndex != -1) {
      final deleteDelta = Delta()
        ..retain(pollIndex)
        ..delete(pollLength);

      controller.compose(
        deleteDelta,
        TextSelection.collapsed(offset: pollIndex),
        ChangeSource.local,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayNotifierProvider);
    final selectedHour = ref.watch(selectedHourNotifierProvider);

    return Column(
      children: [
        QuillEditor.basic(
          controller: controller,
          configurations: QuillEditorConfigurations(
            embedBuilders: [
              TextEditorSingleImageBuilder(),
              TextEditorPollBuilder(
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
                onRemovePollPress: _removePoll,
              ),
            ],
            autoFocus: true,
            placeholder: placeholder,
            customStyles: _getCustomStyles(context),
            floatingCursorDisabled: true,
          ),
        ),
      ],
    );
  }

  DefaultStyles _getCustomStyles(BuildContext context) {
    return DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
      ),
      bold: context.theme.appTextThemes.body2.copyWith(
        fontWeight: FontWeight.bold,
        color: context.theme.appColors.primaryText,
      ),
      italic: context.theme.appTextThemes.body2.copyWith(
        fontStyle: FontStyle.italic,
        color: context.theme.appColors.primaryText,
      ),
      placeHolder: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
      ),
    );
  }
}
