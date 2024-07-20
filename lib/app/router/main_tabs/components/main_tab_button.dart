import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';
import 'package:ice/generated/assets.gen.dart';

class MainTabButton extends ConsumerWidget {
  const MainTabButton({
    required this.navigationShell,
    required this.currentTab,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final TabItem Function() currentTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isModalOpen = currentLocation.endsWith('/main-modal');

    final icon = isModalOpen
        ? Assets.images.logo.logoButtonClose
        : Assets.images.logo.logoButton;

    return SizedBox(
      width: 50,
      height: 50,
      child: icon.image(fit: BoxFit.contain),
    );
  }

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final bottomSheetState = ref.watch(bottomSheetStateProvider);
  //   final isModalOpen = bottomSheetState[currentTab()] ?? false;

  //   final icon = isModalOpen
  //       ? Assets.images.logo.logoButtonClose
  //       : Assets.images.logo.logoButton;

  //   return SizedBox(
  //     width: 50,
  //     height: 50,
  //     child: icon.image(fit: BoxFit.contain),
  //   );
  // }
}
