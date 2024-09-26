import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/extensions.dart';

class AddImagesButton extends StatelessWidget {
  const AddImagesButton({
    required this.mediaCount,
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;
  final int mediaCount;

  @override
  Widget build(BuildContext context) {
    final notSelected = mediaCount == 0;
    final text = context.i18n.button_add;

    return TextButton(
      onPressed: notSelected ? null : onPressed,
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          notSelected ? text : '$text ($mediaCount)',
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
