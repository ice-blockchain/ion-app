import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_code_block.dart';

class TextEditorCodeButton extends StatelessWidget {
  TextEditorCodeButton(this._controller);

  final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final index = _controller.selection.baseOffset;

        _controller.replaceText(
          index,
          0,
          TextEditorCodeEmbed('''
void main() async {
  runApp(
    ProviderScope(
      observers: <ProviderObserver>[
        if (LoggerConfig.riverpodLogsEnabled) RiverpodLogger(),
      ],
      child: const IceApp(),
    ),
  );
}'''),
          TextSelection.collapsed(
            offset: _controller.document.length,
          ),
        );
        _controller.replaceText(
          index + 1,
          0,
          "\n",
          TextSelection.collapsed(
            offset: _controller.document.length,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: context.theme.appColors.primaryText,
          ),
        ),
        child: Icon(
          size: 20,
          Icons.code,
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
