import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

ButtonStyle outlined(BuildContext context) {
  return FilledButton.styleFrom(
    foregroundColor: context.theme.appColors.primaryText,
    side: BorderSide(color: context.theme.appColors.onTerararyFill),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    minimumSize: const Size(38, 38),
    padding: const EdgeInsets.symmetric(horizontal: 4),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: context.theme.appTextThemes.subtitle2,
    backgroundColor: context.theme.appColors.tertararyBackground,
  );
}

//rename PrimaryButton

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.style,
    this.mainAxisSize = MainAxisSize.min,
  });

  final void Function()? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final ButtonStyle? style;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: style,
      child: Row(
        mainAxisSize: mainAxisSize,
        children: <Widget>[
          if (leadingIcon != null) leadingIcon!,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: label,
          ),
          if (trailingIcon != null) trailingIcon!,
        ],
      ),
    );
  }
}
