// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/extensions.dart';

class AddMediaButton extends StatelessWidget {
  const AddMediaButton({
    required this.mediaCount,
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;
  final int mediaCount;

  @override
  Widget build(BuildContext context) {
    final text = context.i18n.button_add;

    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          '$text ($mediaCount)',
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
