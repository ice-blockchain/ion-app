// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum OffsetType { large, small }

class SimpleModalSheet extends StatelessWidget {
  factory SimpleModalSheet.info({
    required String title,
    required String description,
    required String iconAsset,
    String? buttonText,
    VoidCallback? onPressed,
    Widget? button,
    bool isBottomSheet = false,
  }) {
    return SimpleModalSheet._(
      title: title,
      description: description,
      iconAsset: iconAsset,
      buttonText: buttonText,
      onPressed: onPressed,
      button: button,
      offsetType: OffsetType.large,
      isBottomSheet: isBottomSheet,
    );
  }

  factory SimpleModalSheet.alert({
    required String title,
    required String description,
    required String iconAsset,
    String? buttonText,
    VoidCallback? onPressed,
    Widget? button,
    bool isBottomSheet = false,
  }) {
    return SimpleModalSheet._(
      title: title,
      description: description,
      iconAsset: iconAsset,
      buttonText: buttonText,
      onPressed: onPressed,
      button: button,
      offsetType: OffsetType.small,
      isBottomSheet: isBottomSheet,
    );
  }

  const SimpleModalSheet._({
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.offsetType,
    this.buttonText,
    this.onPressed,
    this.button,
    this.isBottomSheet = false,
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
  final bool isBottomSheet;

  @override
  Widget build(BuildContext context) {
    final content = Column(
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
        button ??
            _CommonButton(
              text: buttonText!,
              onPressed: onPressed!,
              offsetType: offsetType,
            ),
        ScreenBottomOffset(margin: 36.0.s),
      ],
    );

    return isBottomSheet
        ? content
        : SheetContent(
            body: content,
          );
  }
}

class _CommonButton extends StatelessWidget {
  const _CommonButton({
    required this.text,
    required this.onPressed,
    required this.offsetType,
  });

  final String text;
  final VoidCallback onPressed;
  final OffsetType offsetType;

  @override
  Widget build(BuildContext context) {
    final button = Button(
      mainAxisSize: MainAxisSize.max,
      label: Text(text),
      onPressed: onPressed,
    );

    return offsetType == OffsetType.large
        ? ScreenSideOffset.large(child: button)
        : ScreenSideOffset.small(child: button);
  }
}
