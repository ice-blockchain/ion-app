import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/main_tabs/components/main_tab_navigation_container.dart';

void useScrollTopOnTabPress(BuildContext context, {required ScrollController scrollController}) {
  final tabPressStream = MainTabNavigationContainer.of(context).tabPressStream;
  final screenTab = GoRouterState.of(context).currentTab;

  useEffect(() {
    final listener = tabPressStream.listen((tabPressData) {
      if (tabPressData.current == screenTab && tabPressData.current == tabPressData.pressed) {
        scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      }
    });
    return () => listener.cancel();
  }, [tabPressStream, screenTab]);
}
