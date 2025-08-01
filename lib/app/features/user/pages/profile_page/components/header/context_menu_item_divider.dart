// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ContextMenuItemDivider extends StatelessWidget {
  const ContextMenuItemDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: context.theme.appColors.onTertiaryFill,
      thickness: 0.5.s,
      height: 0.5.s,
    );
  }
}
