// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/generated/assets.gen.dart';

class ToolbarListDotsButton extends StatelessWidget {
  const ToolbarListDotsButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconArticleListdots,
      onPressed: () {},
    );
  }
}
