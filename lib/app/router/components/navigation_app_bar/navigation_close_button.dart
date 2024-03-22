import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class NavigationCloseButton extends StatelessWidget {
  const NavigationCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Assets.images.icons.iconSheetClose.icon(
          color: context.theme.appColors.tertararyText,
        ),
      ),
      onPressed: () => context.pop(),
    );
  }
}
