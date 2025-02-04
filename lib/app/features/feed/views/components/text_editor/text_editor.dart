// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/text_editor_poll_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/mentions_hashtags_handler.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/quill.dart';

class TextEditor extends ConsumerStatefulWidget {
  const TextEditor(
    this.controller, {
    super.key,
    this.placeholder,
    this.focusNode,
    this.autoFocus = true,
  });

  final QuillController controller;
  final String? placeholder;
  final FocusNode? focusNode;
  final bool autoFocus;

  @override
  TextEditorState createState() => TextEditorState();
}

class TextEditorState extends ConsumerState<TextEditor> {
  late MentionsHashtagsHandler _mentionsHashtagsHandler;
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    _mentionsHashtagsHandler = MentionsHashtagsHandler(
      controller: widget.controller,
      focusNode: _focusNode,
      context: context,
      ref: ref,
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
    return QuillEditor.basic(
      controller: widget.controller,
      focusNode: _focusNode,
      configurations: QuillEditorConfigurations(
        embedBuilders: [
          TextEditorSingleImageBuilder(),
          TextEditorPollBuilder(
            controller: widget.controller,
          ),
          TextEditorSeparatorBuilder(),
          TextEditorCodeBuilder(),
        ],
        autoFocus: widget.autoFocus,
        placeholder: widget.placeholder,
        customStyles: getCustomStyles(context),
        floatingCursorDisabled: true,
        customStyleBuilder: (attribute) => customTextStyleBuilder(attribute, context),
      ),
    );
  }
}
