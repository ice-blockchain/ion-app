// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ActionsToolbarButton extends StatelessWidget {
  const ActionsToolbarButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.iconSelected,
    this.selected = false,
  });

  final VoidCallback onPressed;
  final String icon;
  final String? iconSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: (selected && iconSelected != null ? iconSelected! : icon).icon(
        size: 24.0.s,
        color: context.theme.appColors.primaryAccent,
      ),
    );
  }
}
