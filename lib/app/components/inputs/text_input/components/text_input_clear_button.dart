// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class TextInputClearButton extends StatelessWidget {
  const TextInputClearButton({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: controller.clear,
      icon: const IconAsset(Assets.svgIconFieldClearall),
    );
  }
}
