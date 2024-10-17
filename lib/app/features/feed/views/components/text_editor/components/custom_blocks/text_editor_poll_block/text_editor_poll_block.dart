// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/poll/poll_length_time_provider.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_add_answer_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_answers_list_view.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_close_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_length_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_title.dart';
import 'package:ice/app/features/feed/views/pages/poll_length_time_modal/poll_length_time_modal.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:intl/intl.dart';

const textEditorPollKey = 'text-editor-poll';

///
/// Embeds a poll in the text editor.
///
class TextEditorPollEmbed extends CustomBlockEmbed {
  TextEditorPollEmbed() : super(textEditorPollKey, '');
}

///
/// Embed builder for [TextEditorPollBuilder].
///
class TextEditorPollBuilder extends EmbedBuilder {
  TextEditorPollBuilder({
    required this.controller,
    required this.ref,
  });

  final QuillController controller;
  final WidgetRef ref;

  @override
  String get key => textEditorPollKey;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final selectedDay = ref.watch(selectedDayNotifierProvider);
    final selectedHour = ref.watch(selectedHourNotifierProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 23.0.s),
          child: Column(
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
                  padding: EdgeInsets.symmetric(horizontal: 10.0.s),
                  child: const Column(
                    children: [
                      PollTitle(),
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
        ),
        PollCloseButton(
          onClosePress: () => _removePoll(node),
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
