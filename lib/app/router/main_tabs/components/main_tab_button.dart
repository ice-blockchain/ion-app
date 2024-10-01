// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class MainTabButton extends StatelessWidget {
  const MainTabButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);

    final icon =
        state.isMainModalOpen ? Assets.images.logo.logoButtonClose : Assets.images.logo.logoButton;

    return SizedBox(
      width: 50,
      height: 50,
      child: icon.icon(fit: BoxFit.contain),
    );
  }
}
