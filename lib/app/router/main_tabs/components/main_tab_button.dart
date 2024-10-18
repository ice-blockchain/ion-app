// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class MainTabButton extends StatelessWidget {
  const MainTabButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);

    final icon =
        state.isMainModalOpen ? Assets.images.logo.logoButtonClose : Assets.images.logo.logoButton;

    return SizedBox.square(
      dimension: 50.0.s,
      child: icon.icon(fit: BoxFit.contain),
    );
  }
}
