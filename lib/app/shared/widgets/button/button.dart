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
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.mainAxisSize = MainAxisSize.min,
  });

  factory Button.icon({
    Key? key,
    required ButtonType type,
    required Widget image,
  }) = _ButtonWithIcon;

  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final MainAxisSize mainAxisSize;

  @protected
  Widget? buildLeadingIcon(
    BuildContext context,
  ) {
    return leadingIcon;
  }

  @override
  Widget build(BuildContext context) {
    final Widget? icon = buildLeadingIcon(context);

    return ElevatedButton(
      onPressed: onPressed ?? () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[icon],
          if (label != null) ...<Widget>[
            const SizedBox(width: 8),
            label!,
          ],
        ],
      ),
    );
  }
}
