// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/utils/quill.dart';

class ArticleContent extends StatelessWidget {
  const ArticleContent({super.key});

  QuillController _getMockedController() {
    final encodedContent = jsonEncode(mockedData);
    return decodeArticleContent(encodedContent);
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _getMockedController(),
      configurations: QuillEditorConfigurations(
        enableSelectionToolbar: false,
        floatingCursorDisabled: true,
        showCursor: false,
        enableInteractiveSelection: false,
        embedBuilders: [
          TextEditorSingleImageBuilder(),
          TextEditorSeparatorBuilder(),
          TextEditorCodeBuilder(),
        ],
        disableClipboard: true,
      ),
    );
  }
}

final mockedData = [
  {'insert': 'Header1'},
  {
    'insert': '\n',
    'attributes': {'header': 1},
  },
  {'insert': 'Header2'},
  {
    'insert': '\n',
    'attributes': {'header': 2},
  },
  {'insert': 'Header3'},
  {
    'insert': '\n',
    'attributes': {'header': 3},
  },
  {'insert': 'Regular\n'},
  {
    'insert': 'Bold',
    'attributes': {'bold': true},
  },
  {'insert': '\n'},
  {
    'insert': 'Italic',
    'attributes': {'italic': true},
  },
  {'insert': '\n'},
  {
    'insert': 'Underlined',
    'attributes': {'underline': true},
  },
  {'insert': '\n'},
  {
    'insert': 'Link',
    'attributes': {'link': 'http://example.com'},
  },
  {'insert': '\n\nList dots\nOne'},
  {
    'insert': '\n',
    'attributes': {'list': 'bullet'},
  },
  {'insert': 'Two'},
  {
    'insert': '\n',
    'attributes': {'list': 'bullet'},
  },
  {'insert': 'Three'},
  {
    'insert': '\n',
    'attributes': {'list': 'bullet'},
  },
  {'insert': '\nQuote\nQuote example'},
  {
    'insert': '\n',
    'attributes': {'blockquote': true},
  },
  {'insert': '\n'},
  {
    'insert': '@Timechain',
    'attributes': {'mention': '@Timechain'},
  },
  {'insert': ' \n\nHashtags\n'},
  {
    'insert': '#Habits',
    'attributes': {'hashtag': '#Habits'},
  },
  {'insert': ' \n\nSeparator\n\n'},
  {
    'insert': {'custom': '{"text-editor-separator":""}'},
  },
  {'insert': '\nAnd code example\n\n'},
  {
    'insert': {'custom': '{"text-editor-code":""}'},
  },
  {'insert': '\n\n\n'},
];
