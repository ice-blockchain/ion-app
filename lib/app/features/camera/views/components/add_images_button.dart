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
  final String imageCount;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          'Add ($imageCount)',
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
