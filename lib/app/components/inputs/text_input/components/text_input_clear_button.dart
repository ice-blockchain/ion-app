import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class TextInputClearButton extends StatelessWidget {
  const TextInputClearButton({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: controller.clear,
      icon: Padding(
        padding: EdgeInsets.all(6.0.s),
        child: Assets.images.icons.iconSheetClose
            .icon(size: 16.0.s, color: context.theme.appColors.secondaryText),
      ),
    );
  }
}
