// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';

class WalletTabsHeaderTab extends StatelessWidget {
  const WalletTabsHeaderTab({
    required this.isActive,
    required this.title,
    required this.onTap,
    super.key,
  });

  final bool isActive;
  final String title;
  final VoidCallback onTap;

  Color _getColor(BuildContext context) {
    return isActive ? context.theme.appColors.primaryText : context.theme.appColors.tertiaryText;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          title,
          style: context.theme.appTextThemes.title.copyWith(
            color: _getColor(context),
          ),
        ),
      ),
    );
  }
}
