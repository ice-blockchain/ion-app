// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

// ButtonStyle outlined(BuildContext context) {
//   return FilledButton.styleFrom(
//     foregroundColor: context.theme.appColors.primaryText,
//     side: BorderSide(color: context.theme.appColors.onTerararyFill),
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(12)),
//     ),
//     minimumSize: const Size(38, 38),
//     padding: const EdgeInsets.symmetric(horizontal: 4),
//     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     textStyle: context.theme.appTextThemes.subtitle2,
//     backgroundColor: context.theme.appColors.tertararyBackground,
//   );
// }

class Button extends StatelessWidget {
  const Button._({
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.style,
    this.mainAxisSize = MainAxisSize.min,
  });

  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final ButtonStyle? style;
  final MainAxisSize mainAxisSize;

  static Widget iconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    IconData? iconData,
    String? imagePath,
    ButtonStyle? style,
    Color? backgroundColor,
    Color? iconTintColor,
    Color? borderColor,
    double borderWidth = 0.0,
    BorderRadius? borderRadius,
  }) {
    assert(
      iconData != null || imagePath != null,
      'You must provide either an iconData or an imagePath',
    );
    final IconButtonThemeData iconButtonTheme = context.theme.iconButtonTheme;
    final IconThemeData iconTheme = context.theme.iconTheme;

    final ButtonStyle mergedButtonStyle =
        iconButtonTheme.style?.merge(style) ?? style ?? const ButtonStyle();

    Widget iconWidget;
    if (iconData != null) {
      iconWidget = Icon(
        iconData,
        size: iconTheme.size,
        color: iconTintColor,
      );
    } else {
      iconWidget = Image.asset(
        imagePath!,
        width: iconTheme.size,
        height: iconTheme.size,
      );
    }

    return Container(
      decoration: BoxDecoration(
        // color:
        //     iconButtonTheme.style?.backgroundColor?.resolve(<MaterialState>{}),
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: iconWidget,
          onPressed: onPressed,
          style: mergedButtonStyle,
        ),
      ),
    );
  }

  static Widget primaryIconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    IconData? iconData,
    String? imagePath,
  }) {
    return iconButton(
      context: context,
      onPressed: onPressed,
      iconData: iconData,
      imagePath: imagePath,
      backgroundColor: context.theme.appColors.primaryAccent,
      iconTintColor: context.theme.appColors.onPrimaryAccent,
    );
  }

  static Widget secondaryIconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    IconData? iconData,
    String? imagePath,
  }) {
    return iconButton(
      context: context,
      onPressed: onPressed,
      iconData: iconData,
      imagePath: imagePath,
      backgroundColor: context.theme.appColors.onPrimaryAccent,
      iconTintColor: context.theme.appColors.secondaryText,
    );
  }

  static Widget disabledIconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    IconData? iconData,
    String? imagePath,
  }) {
    return iconButton(
      context: context,
      onPressed: onPressed,
      iconData: iconData,
      imagePath: imagePath,
      backgroundColor: context.theme.appColors.sheetLine,
      iconTintColor: context.theme.appColors.secondaryBackground,
    );
  }

  static Widget outlinedIconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    IconData? iconData,
    String? imagePath,
  }) {
    return iconButton(
      context: context,
      onPressed: onPressed,
      iconData: iconData,
      imagePath: imagePath,
      backgroundColor: Colors.transparent,
      iconTintColor: context.theme.appColors.secondaryText,
      borderColor: context.theme.appColors.strokeElements,
      borderWidth: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (leadingIcon != null) ...<Widget>[leadingIcon!],
          if (label != null) ...<Widget>[
            const SizedBox(
              width: 8,
            ),
            label!,
          ],
        ],
      ),
    );
  }
}
