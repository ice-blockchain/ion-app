import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class SearchCancelButton extends StatelessWidget {
  const SearchCancelButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(12.0.s, 0, 0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(0, 40.0.s),
          padding: EdgeInsets.only(right: 12.0.s),
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
