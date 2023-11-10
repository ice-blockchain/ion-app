// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';

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
    required IconData iconData,
  }) {
    final IconButtonThemeData iconButtonTheme = context.theme.iconButtonTheme;
    final IconThemeData iconTheme = context.theme.iconTheme;

    return Container(
      decoration: BoxDecoration(
        color:
            iconButtonTheme.style?.backgroundColor?.resolve(<MaterialState>{}),
        borderRadius:
            BorderRadius.circular(8), // Optional: if you want rounded corners
      ),
      child: IconButton(
        icon: Icon(
          iconData,
          size: iconTheme.size,
          color: iconTheme.color,
        ),
        onPressed: onPressed,
        style: iconButtonTheme.style,
      ),
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
