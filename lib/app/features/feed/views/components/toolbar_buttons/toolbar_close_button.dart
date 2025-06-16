// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarCloseButton extends StatelessWidget {
  const ToolbarCloseButton({
    required this.textEditorController,
    required this.onPressed,
    super.key,
  });
  final QuillController textEditorController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svgIconSheetClose,
      onPressed: onPressed,
    );
  }
}
