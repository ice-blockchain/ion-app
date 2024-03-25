import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TextInputTextButton extends StatelessWidget {
  const TextInputTextButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(14.0.s),
        child: Text(
          label,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
