import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
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
      child: Column(
        children: [
          Container(
            height: 1.0.s,
            width: double.infinity,
            color: Theme.of(context).appColors.onTerararyFill,
          ),
          SizedBox(height: 6.0.s),
          ScreenSideOffset.small(
            child: Row(
              children: [
                ...actions,
                Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
