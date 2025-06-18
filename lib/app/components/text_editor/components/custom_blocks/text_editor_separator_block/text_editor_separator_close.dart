// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class TextEditorSeparatorClose extends StatelessWidget {
  const TextEditorSeparatorClose({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: context.theme.appColors.primaryAccent,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPressed,
      icon: const IconAsset(Assets.svgIconFieldClearall, size: 20),
    );
  }
}
