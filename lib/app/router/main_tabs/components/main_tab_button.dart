import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';
import 'package:ice/app/router/utils/go_router_state_extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class MainTabButton extends StatelessWidget {
  const MainTabButton({
    required this.navigationShell,
    required this.currentTab,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final TabItem Function() currentTab;

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);

    final icon = state.isMainModalOpen
        ? Assets.images.logo.logoButtonClose
        : Assets.images.logo.logoButton;

    return SizedBox(
      width: 50,
      height: 50,
      child: icon.image(fit: BoxFit.contain),
    );
  }
}
