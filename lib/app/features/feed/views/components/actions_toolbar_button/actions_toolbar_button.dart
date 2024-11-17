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
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final String icon;
  final String? iconSelected;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: (selected && iconSelected != null ? iconSelected! : icon).icon(
        size: 24.0.s,
        color: enabled ? context.theme.appColors.primaryAccent : context.theme.appColors.sheetLine,
      ),
    );
  }
}
