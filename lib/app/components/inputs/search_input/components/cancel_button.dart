import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class SearchCancelButton extends StatelessWidget {
  const SearchCancelButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSize.xxxSmall),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(0, 40.0.s),
          padding: EdgeInsets.symmetric(horizontal: UiSize.xxSmall),
        ),
        child: Text(
          context.i18n.button_cancel,
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.primaryAccent),
        ),
      ),
    );
  }
}
