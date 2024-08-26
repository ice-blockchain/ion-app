import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';

typedef TabPressSteamData = ({TabItem current, TabItem pressed});

class MainTabNavigationContainer extends InheritedWidget {
  const MainTabNavigationContainer({
    super.key,
    required super.child,
    required this.tabPressStream,
  });

  final Stream<TabPressSteamData> tabPressStream;

  static MainTabNavigationContainer of(BuildContext context) {
    final MainTabNavigationContainer? result =
        context.dependOnInheritedWidgetOfExactType<MainTabNavigationContainer>();
    assert(result != null, 'No MainTabNavigationContainer found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(MainTabNavigationContainer oldWidget) =>
      oldWidget.tabPressStream != tabPressStream;
}
