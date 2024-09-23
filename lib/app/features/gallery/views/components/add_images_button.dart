import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/extensions.dart';

class AddImagesButton extends StatelessWidget {
  const AddImagesButton({
    super.key,
    required this.imageCount,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final int imageCount;

  @override
  Widget build(BuildContext context) {
    final bool notSelected = imageCount == 0;
    final text = context.i18n.button_add;

    return TextButton(
      onPressed: notSelected ? null : onPressed,
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          notSelected ? text : '$text ($imageCount)',
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
