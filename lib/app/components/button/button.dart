// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

part 'variants/button_compact.dart';
part 'variants/button_dropdown.dart';
part 'variants/button_icon.dart';
part 'variants/button_menu.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
  disabled,
  menuInactive,
  menuActive,
  dropdown,
}

class Button extends StatelessWidget {
  Button({
    required this.onPressed,
    super.key,
    this.trailingIcon,
    this.leadingIcon,
    this.label,
    this.style = const ButtonStyle(),
    this.mainAxisSize = MainAxisSize.min,
    this.type = ButtonType.primary,
    this.disabled = false,
    this.tintColor,
    this.borderColor,
    this.borderRadius,
    this.backgroundColor,
    this.minimumSize,
    double? leadingIconOffset,
    double? trailingIconOffset,
  })  : leadingIconOffset = leadingIconOffset ?? UiSize.small,
        trailingIconOffset = trailingIconOffset ?? UiSize.small;

  factory Button.icon({
    required VoidCallback onPressed,
    required Widget icon,
    Key? key,
    ButtonType type,
    ButtonStyle style,
    Color? tintColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double size,
  }) = _ButtonWithIcon;

  factory Button.compact({
    required VoidCallback onPressed,
    Key? key,
    Widget? trailingIcon,
    Widget? leadingIcon,
    Widget? label,
    ButtonStyle style,
    MainAxisSize mainAxisSize,
    ButtonType type,
    bool disabled,
    Color? tintColor,
    Color? backgroundColor,
    Size? minimumSize,
  }) = _ButtonCompact;

  factory Button.menu({
    required VoidCallback onPressed,
    Key? key,
    Widget? trailingIcon,
    Widget? leadingIcon,
    Widget? label,
    ButtonStyle style,
    MainAxisSize mainAxisSize,
    Color? borderColor,
    Color? backgroundColor,
    bool disabled,
    bool active,
  }) = _ButtonMenu;

  factory Button.dropdown({
    required VoidCallback onPressed,
    Key? key,
    Widget? leadingIcon,
    Widget? label,
    ButtonStyle style,
    Color? borderColor,
    Color? backgroundColor,
    double? leadingButtonOffset,
    double? trailingIconOffset,
    bool disabled,
    bool opened,
  }) = _ButtonDropdown;

  final VoidCallback onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Size? minimumSize;
  final Color? tintColor;
  final ButtonStyle style;
  final MainAxisSize mainAxisSize;
  final ButtonType type;
  final bool disabled;
  final double leadingIconOffset;
  final double trailingIconOffset;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: type == ButtonType.disabled || disabled ? null : onPressed,
      style: style.merge(
        OutlinedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.all(Radius.circular(UiSize.large)),
          ),
          minimumSize: minimumSize ?? Size(56.0.s, 56.0.s),
          padding: EdgeInsets.symmetric(horizontal: UiSize.large),
          backgroundColor: _getBackgroundColor(context, type),
          side: BorderSide(
            color: _getBorderColor(context, type),
          ),
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: _getIconTintColor(context, type)),
        child: DefaultTextStyle(
          overflow: TextOverflow.ellipsis,
          style: context.theme.appTextThemes.body
              .copyWith(color: _getLabelColor(context, type)),
          child: Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (leadingIcon != null) leadingIcon!,
              if (label != null)
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: leadingIcon == null ? 0 : leadingIconOffset,
                      right: trailingIcon == null ? 0 : trailingIconOffset,
                    ),
                    child: label,
                  ),
                ),
              if (trailingIcon != null) trailingIcon!,
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context, ButtonType type) {
    return backgroundColor ??
        switch (type) {
          ButtonType.primary => context.theme.appColors.primaryAccent,
          ButtonType.secondary => context.theme.appColors.tertararyBackground,
          ButtonType.outlined => Colors.transparent,
          ButtonType.disabled => context.theme.appColors.sheetLine,
          ButtonType.menuInactive =>
            context.theme.appColors.tertararyBackground,
          ButtonType.menuActive => context.theme.appColors.secondaryBackground,
          ButtonType.dropdown => context.theme.appColors.tertararyBackground,
        };
  }

  Color _getBorderColor(BuildContext context, ButtonType type) {
    return borderColor ??
        tintColor ??
        switch (type) {
          ButtonType.primary => context.theme.appColors.onPrimaryAccent,
          ButtonType.secondary => context.theme.appColors.tertararyBackground,
          ButtonType.outlined => context.theme.appColors.strokeElements,
          ButtonType.disabled => context.theme.appColors.sheetLine,
          ButtonType.menuInactive => context.theme.appColors.onTerararyFill,
          ButtonType.menuActive => context.theme.appColors.primaryAccent,
          ButtonType.dropdown => context.theme.appColors.onTerararyFill,
        };
  }

  Color _getLabelColor(BuildContext context, ButtonType type) {
    return tintColor ??
        switch (type) {
          ButtonType.primary => context.theme.appColors.onPrimaryAccent,
          ButtonType.secondary => context.theme.appColors.primaryText,
          ButtonType.outlined => context.theme.appColors.secondaryText,
          ButtonType.disabled => context.theme.appColors.onPrimaryAccent,
          ButtonType.menuInactive => context.theme.appColors.tertararyText,
          ButtonType.menuActive => context.theme.appColors.primaryText,
          ButtonType.dropdown => context.theme.appColors.primaryText,
        };
  }

  Color _getIconTintColor(BuildContext context, ButtonType type) {
    return tintColor ??
        switch (type) {
          ButtonType.primary => context.theme.appColors.onPrimaryAccent,
          ButtonType.secondary => context.theme.appColors.primaryAccent,
          ButtonType.outlined => context.theme.appColors.secondaryText,
          ButtonType.disabled => context.theme.appColors.onPrimaryAccent,
          ButtonType.menuInactive => context.theme.appColors.tertararyText,
          ButtonType.menuActive => context.theme.appColors.primaryAccent,
          ButtonType.dropdown => context.theme.appColors.primaryText,
        };
  }
}

class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: UiSize.medium,
      height: UiSize.medium,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}

class ButtonIconFrame extends StatelessWidget {
  const ButtonIconFrame({
    required this.icon,
    super.key,
    this.color,
  });

  final Color? color;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.0.s,
      height: 32.0.s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9.0.s),
      ),
      child: icon,
    );
  }
}
