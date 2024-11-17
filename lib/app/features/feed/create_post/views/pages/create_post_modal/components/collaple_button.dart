import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class CollapseButton extends StatelessWidget {
  const CollapseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context.pop,
      icon: Assets.svg.iconFeedScale.icon(
        color: context.theme.appColors.quaternaryText,
        size: 18.0.s,
      ),
    );
  }
}
