// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

part 'variants/button_compact.dart';
part 'variants/button_icon.dart';

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
    this.trailingIcon,
    this.leadingIcon,
    this.label,
    this.style = const ButtonStyle(),
    this.mainAxisSize = MainAxisSize.min,
    this.type = ButtonType.primary,
    this.disabled = false,
    this.tintColor,
    this.borderColor,
    this.backgroundColor,
    this.minimumSize,
    this.disableRipple,
  });

  factory Button.icon({
    Key? key,
    required VoidCallback onPressed,
    required Widget icon,
    ButtonType type,
    ButtonStyle style,
    Color? tintColor,
    Color? borderColor,
    Color? backgroundColor,
    double size,
  }) = _ButtonWithIcon;

  factory Button.compact({
    Key? key,
    required VoidCallback onPressed,
    Widget? trailingIcon,
    Widget? leadingIcon,
    Widget? label,
    ButtonStyle style,
    MainAxisSize mainAxisSize,
    ButtonType type,
    bool disabled,
    Color? tintColor,
  }) = _ButtonCompact;

  final VoidCallback onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final Color? borderColor;
  final Color? backgroundColor;
  final Size? minimumSize;
  final bool? disableRipple;
  final Color? tintColor;
  final ButtonStyle style;
  final MainAxisSize mainAxisSize;
  final ButtonType type;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: type == ButtonType.disabled || disabled ? null : onPressed,
      style: style
          .merge(
        OutlinedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
          ),
          minimumSize: minimumSize ?? Size(56.0.s, 56.0.s),
          padding: EdgeInsets.symmetric(horizontal: 16.0.s),
          backgroundColor: _getBackgroundColor(context, type),
          side: BorderSide(
            color: _getBorderColor(context, type),
          ),
        ),
      )
          .merge(
        ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              return disableRipple == true ? Colors.transparent : null;
            },
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
                      left: leadingIcon == null
                          ? 0
                          : 8.0.s, // 8 move to constants
                      right: trailingIcon == null ? 0 : 8.0.s,
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
        };
  }

  Color _getLabelColor(BuildContext context, ButtonType type) {
    return tintColor ??
        switch (type) {
          ButtonType.primary => context.theme.appColors.onPrimaryAccent,
          ButtonType.secondary => context.theme.appColors.primaryText,
          ButtonType.outlined => context.theme.appColors.secondaryText,
          ButtonType.disabled => context.theme.appColors.onPrimaryAccent,
        };
  }

  Color _getIconTintColor(BuildContext context, ButtonType type) {
    return tintColor ??
        switch (type) {
          ButtonType.primary => context.theme.appColors.onPrimaryAccent,
          ButtonType.secondary => context.theme.appColors.primaryAccent,
          ButtonType.outlined => context.theme.appColors.secondaryText,
          ButtonType.disabled => context.theme.appColors.onPrimaryAccent,
        };
  }
}

class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12.0.s,
      height: 12.0.s,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  ButtonIcon(
    this.path, {
    super.key,
    double? size,
    this.color,
  }) : size = size ?? 24.0.s;

  final String path;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: ImageIcon(AssetImage(path), color: color),
      ),
    );
  }
}
