import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

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
      height: 40.0.s,
      child: Row(
        children: [
          ...actions,
          Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
