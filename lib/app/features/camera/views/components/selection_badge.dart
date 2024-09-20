import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class SelectionBadge extends StatelessWidget {
  SelectionBadge({
    super.key,
    required this.selectionOrder,
  });

  final String selectionOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0.s,
      height: 20.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryAccent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$selectionOrder',
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.secondaryBackground,
            fontSize: 12.0.s,
          ),
        ),
      ),
    );
  }
}
