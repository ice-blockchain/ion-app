import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SimpleModalSheet extends StatelessWidget {
  const SimpleModalSheet({
    super.key,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.buttonText,
    required this.onPressed,
    this.button,
  }) : assert(
          (button != null) || (buttonText != null && onPressed != null),
          'Either button or both buttonText and onPressed must be provided',
        );

  final String title;
  final String description;
  final AssetGenImage iconAsset;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0.s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.s),
            child: Column(
              children: [
                InfoCard(
                  iconAsset: iconAsset,
                  title: title,
                  description: description,
                ),
                SizedBox(height: 20.0.s),
                button ??
                    Button(
                      mainAxisSize: MainAxisSize.max,
                      label: Text(buttonText!),
                      onPressed: onPressed!,
                    ),
                ScreenBottomOffset(margin: 36.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
