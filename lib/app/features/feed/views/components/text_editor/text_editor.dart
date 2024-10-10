// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/text_editor_poll_block.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ice/app/features/feed/views/pages/poll_length_time_modal/poll_length_time_modal.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/app/services/logger/logger.dart';

extension DeltaPollExtension on Delta {
  void removePoll(String embedKey) {
    final index = operations.indexWhere((operation) {
      return operation.isInsert &&
          operation.data is Map<String, dynamic> &&
          (operation.data! as Map<String, dynamic>).containsKey(embedKey);
    });

    if (index != -1) {
      final length = operations[index].length ?? 1;
      delete(length);
    }
  }
}

class TextEditor extends StatelessWidget {
  const TextEditor(
    this.controller, {
    super.key,
    this.placeholder,
  });
  final QuillController controller;
  final String? placeholder;

  Future<void> _showPollLengthTimeModal(BuildContext context) async {
    return showSimpleBottomSheet<void>(
      context: context,
      child: const PollLengthTimeModal(),
    );
  }

  void _removePoll(Embed node) {
    final delta = controller.document.toDelta();

    var currentIndex = 0;
    var pollIndex = -1;
    var pollLength = 0;

    for (var i = 0; i < delta.operations.length; i++) {
      final operation = delta.operations[i];
      final length = operation.length ?? 1;

      if (operation.isInsert && operation.data is Map<String, dynamic>) {
        final data = operation.data! as Map<String, dynamic>;

        if (data.containsKey('custom')) {
          final customData = data['custom'];
          if (customData is Map<String, dynamic> && customData.containsKey(textEditorPollKey)) {
            pollIndex = currentIndex;
            pollLength = length;
            break;
          }
          if (customData is String) {
            try {
              final parsedData = jsonDecode(customData);
              if (parsedData is Map<String, dynamic> && parsedData.containsKey(textEditorPollKey)) {
                pollIndex = currentIndex;
                pollLength = length;
                break;
              }
            } catch (e) {
              Logger.log('Failed to parse custom data as JSON: $e');
            }
          }
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
    } else {
      Logger.log('Poll not found in the document.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillEditor.basic(
          controller: controller,
          configurations: QuillEditorConfigurations(
            embedBuilders: [
              TextEditorSingleImageBuilder(),
              TextEditorPollBuilder(
                onPollLengthPress: () {
                  _showPollLengthTimeModal(context);
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
