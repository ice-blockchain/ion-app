import 'package:flutter/material.dart';
import 'package:ice/app/components/shadow/shadow_container/shadow_container.dart';
import 'package:ice/app/extensions/extensions.dart';

class ShareBottomMenu extends StatelessWidget {
  const ShareBottomMenu({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomBoxShadow(
      child: ColoredBox(
        color: context.theme.appColors.secondaryBackground,
        child: SizedBox(height: 110.0.s, child: child),
      ),
    );
  }
}
