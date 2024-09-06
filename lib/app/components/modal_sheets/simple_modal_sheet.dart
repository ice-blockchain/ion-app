import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

enum OffsetType { large, small }

class SimpleModalSheet extends StatelessWidget {
  const SimpleModalSheet._({
    required this.title,
    required this.description,
    required this.iconAsset,
    this.buttonText,
    this.onPressed,
    this.button,
    required this.offsetType,
  }) : assert(
          (button != null) || (buttonText != null && onPressed != null),
          'Either button or both buttonText and onPressed must be provided',
        );

  final String title;
  final String description;
  final String iconAsset;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Widget? button;
  final OffsetType offsetType;

  factory SimpleModalSheet.info({
    required String title,
    required String description,
    required String iconAsset,
    String? buttonText,
    VoidCallback? onPressed,
    Widget? button,
  }) {
    return SimpleModalSheet._(
      title: title,
      description: description,
      iconAsset: iconAsset,
      buttonText: buttonText,
      onPressed: onPressed,
      button: button,
      offsetType: OffsetType.large,
    );
  }

  factory SimpleModalSheet.alert({
    required String title,
    required String description,
    required String iconAsset,
    String? buttonText,
    VoidCallback? onPressed,
    Widget? button,
  }) {
    return SimpleModalSheet._(
      title: title,
      description: description,
      iconAsset: iconAsset,
      buttonText: buttonText,
      onPressed: onPressed,
      button: button,
      offsetType: OffsetType.small,
    );
  }

  @override
  Widget build(BuildContext context) {
    final commonButton = Button(
      mainAxisSize: MainAxisSize.max,
      label: Text(buttonText!),
      onPressed: onPressed!,
    );

    final offsetButton = offsetType == OffsetType.large
        ? ScreenSideOffset.large(child: commonButton)
        : ScreenSideOffset.small(child: commonButton);

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0.s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.s),
            child: InfoCard(
              iconAsset: iconAsset,
              title: title,
              description: description,
            ),
          ),
          SizedBox(height: 20.0.s),
          button ?? offsetButton,
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }
}
