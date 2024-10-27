// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryInputField extends StatelessWidget {
  const StoryInputField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0.s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: context.theme.appColors.primaryText.withOpacity(0.5),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 9.0.s,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        style: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.onPrimaryAccent,
        ),
        decoration: InputDecoration(
          hintText: context.i18n.write_a_message,
          hintStyle: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
