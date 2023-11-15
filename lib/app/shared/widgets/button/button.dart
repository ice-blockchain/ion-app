// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
part './widgets/button_icon.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
  disabled,
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    this.leadingIcon,
    // this.leadingIconPath,
    this.trailingIcon,
    this.label,
    this.style = const ButtonStyle(),
    this.mainAxisSize = MainAxisSize.min,
    this.type = ButtonType.primary,
  });

  factory Button.icon({
    Key? key,
    required VoidCallback onPressed,
    required Widget icon,
    ButtonType type,
    ButtonStyle style,
    double size,
  }) = _ButtonWithIcon;

  final VoidCallback onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final MainAxisSize mainAxisSize;
  final ButtonType type;
  final ButtonStyle style;

  @protected
  Widget? buildLeadingIcon(
    BuildContext context,
  ) {
    return leadingIcon;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: style.merge(
        OutlinedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: _getBackgroundColor(context, type),
          side: BorderSide(
            color: _getBorderColor(context, type),
          ),
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: _getIconTintColor(context, type)),
        child: DefaultTextStyle(
          style: context.theme.appTextThemes.subtitle2 //CHECK FONT
              .copyWith(color: _getLabelColor(context, type)),
          child: Row(
            mainAxisSize: mainAxisSize,
            children: <Widget>[
              if (leadingIcon != null) leadingIcon!,
              if (label != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: leadingIcon == null ? 0 : 8, // 8 move to constants
                    right: trailingIcon == null ? 0 : 8,
                  ),
                  child: label,
                ),
              if (trailingIcon != null) trailingIcon!,
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context, ButtonType type) {
    final Map<ButtonType, Color> colorMap = <ButtonType, Color>{
      ButtonType.primary: context.theme.appColors.primaryAccent,
      ButtonType.secondary: context.theme.appColors.tertararyBackground,
      ButtonType.outlined: Colors.transparent,
      ButtonType.disabled: context.theme.appColors.sheetLine,
    };

    return colorMap[type] ?? context.theme.appColors.onPrimaryAccent;
  }

  Color _getBorderColor(BuildContext context, ButtonType type) {
    final Map<ButtonType, Color> colorMap = <ButtonType, Color>{
      ButtonType.primary: context.theme.appColors.onPrimaryAccent,
      ButtonType.secondary: context.theme.appColors.tertararyBackground,
      ButtonType.outlined: context.theme.appColors.strokeElements,
      ButtonType.disabled: context.theme.appColors.sheetLine,
    };

    return colorMap[type] ?? context.theme.appColors.onPrimaryAccent;
  }

  Color _getLabelColor(BuildContext context, ButtonType type) {
    final Map<ButtonType, Color> colorMap = <ButtonType, Color>{
      ButtonType.primary: context.theme.appColors.onPrimaryAccent,
      ButtonType.secondary: context.theme.appColors.primaryText,
      ButtonType.outlined: context.theme.appColors.secondaryText,
      ButtonType.disabled: context.theme.appColors.onPrimaryAccent,
    };

    return colorMap[type] ?? context.theme.appColors.onPrimaryAccent;
  }

  Color _getIconTintColor(BuildContext context, ButtonType type) {
    final Map<ButtonType, Color> colorMap = <ButtonType, Color>{
      ButtonType.primary: context.theme.appColors.onPrimaryAccent,
      ButtonType.secondary: context.theme.appColors.primaryAccent,
      ButtonType.outlined: context.theme.appColors.secondaryText,
      ButtonType.disabled: context.theme.appColors.onPrimaryAccent,
    };

    return colorMap[type] ?? context.theme.appColors.onPrimaryAccent;
  }
}
