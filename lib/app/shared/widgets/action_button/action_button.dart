import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
  });

  final void Function()? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
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
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
