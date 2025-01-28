// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class CollapseButton extends StatelessWidget {
  const CollapseButton({required this.textEditorController, super.key});

  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.pop(textEditorController.document),
      icon: Assets.svg.iconFeedScale.icon(
        color: context.theme.appColors.quaternaryText,
        size: 18.0.s,
      ),
    );
  }
}
