import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorPollButton extends StatelessWidget {
  final QuillController textEditorController;
  const TextEditorPollButton({super.key, required this.textEditorController});

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconPostPoll,
      onPressed: () => {},
    );
  }
}
