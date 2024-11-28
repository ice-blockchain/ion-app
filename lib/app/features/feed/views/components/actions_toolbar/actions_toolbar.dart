// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

const toolbarHeight = 40.0;

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
    return Container(
      color: context.theme.appColors.onPrimaryAccent,
      height: toolbarHeight,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: actions.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.0.s),
              itemBuilder: (context, index) => actions[index],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
