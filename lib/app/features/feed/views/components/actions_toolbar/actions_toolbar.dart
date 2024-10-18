// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ActionsToolbar extends StatelessWidget {
  const ActionsToolbar({
    required this.actions,
    this.trailing,
    super.key,
  });

  final List<Widget> actions;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0.s,
      child: Row(
        children: [
          ...actions.intersperse(SizedBox(width: 12.0.s)),
          if (trailing != null) ...[SizedBox(width: 12.0.s), const Spacer(), trailing!],
        ],
      ),
    );
  }
}
