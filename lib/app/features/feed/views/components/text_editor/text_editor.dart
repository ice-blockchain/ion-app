// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/text_editor_poll_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/mentions_hashtags_handler.dart';

class TextEditor extends ConsumerStatefulWidget {
  const TextEditor(
    this.controller, {
    super.key,
    this.placeholder,
  });
  final QuillController controller;
  final String? placeholder;

  @override
  TextEditorState createState() => TextEditorState();
}

class TextEditorState extends ConsumerState<TextEditor> {
  late MentionsHashtagsHandler _mentionsHashtagsHandler;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _mentionsHashtagsHandler = MentionsHashtagsHandler(
      controller: widget.controller,
      focusNode: _focusNode,
      context: context,
    );
    _mentionsHashtagsHandler.initialize();
  }

  @override
  void dispose() {
    _mentionsHashtagsHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillEditor.basic(
          controller: widget.controller,
          focusNode: _focusNode,
          configurations: QuillEditorConfigurations(
            embedBuilders: [
              TextEditorSingleImageBuilder(),
              TextEditorPollBuilder(
                controller: widget.controller,
                ref: ref,
              ),
              TextEditorSeparatorBuilder(),
              TextEditorCodeBuilder(),
            ],
            autoFocus: true,
            placeholder: widget.placeholder,
            customStyles: _getCustomStyles(context),
            floatingCursorDisabled: true,
            customStyleBuilder: (attribute) {
              if (attribute.key == Attribute.link.key) {
                final linkValue = attribute.value as String;
                if (linkValue.startsWith('mention:')) {
                  return TextStyle(
                    color: context.theme.appColors.primaryAccent,
                  );
                } else if (linkValue.startsWith('hashtag:')) {
                  return TextStyle(
                    color: context.theme.appColors.primaryAccent,
                  );
                } else {
                  return TextStyle(
                    decoration: TextDecoration.underline,
                    color: context.theme.appColors.primaryAccent,
                  );
                }
              }
              return const TextStyle();
            },
          ),
        ),
      ],
    );
  }

  DefaultStyles _getCustomStyles(BuildContext context) {
    return DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.secondaryText,
        ),
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
      ),
      bold: context.theme.appTextThemes.body2.copyWith(
        fontWeight: FontWeight.bold,
        color: context.theme.appColors.secondaryText,
      ),
      italic: context.theme.appTextThemes.body2.copyWith(
        fontStyle: FontStyle.italic,
        color: context.theme.appColors.secondaryText,
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
      lists: DefaultListBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.secondaryText,
          fontSize: context.theme.appTextThemes.body2.fontSize,
        ),
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
        null,
      ),
      quote: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
          fontStyle: FontStyle.italic,
        ),
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        BoxDecoration(
          border: Border(
            left: BorderSide(
              color: context.theme.appColors.primaryAccent,
              width: 2.0.s,
            ),
          ),
        ),
      ),
    );
  }
}
