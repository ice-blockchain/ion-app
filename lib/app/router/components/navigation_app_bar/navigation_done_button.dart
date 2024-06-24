import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class NavigationDoneButton extends StatelessWidget {
  const NavigationDoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          context.i18n.core_done,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
      onPressed: () => context.pop(),
    );
  }
}
