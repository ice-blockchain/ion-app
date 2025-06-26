// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/main_tabs/components/components.dart';
import 'package:ion/generated/assets.gen.dart';

enum TabItem {
  feed,
  chat,
  main,
  wallet,
  profile;

  const TabItem();

  Widget getIcon({required bool isSelected}) => switch (this) {
        TabItem.feed => TabIcon(
            icon: Assets.svg.iconHomeOff,
            isSelected: isSelected,
          ),
        TabItem.chat => TabIcon(
            icon: Assets.svg.iconChatOff,
            isSelected: isSelected,
          ),
        TabItem.main => const MainTabButton(),
        TabItem.wallet => TabIcon(
            icon: Assets.svg.iconsWalletOff,
            isSelected: isSelected,
          ),
        TabItem.profile => ProfileTabButton(
            isSelected: isSelected,
          ),
      };

  int get navigationIndex => index > TabItem.main.index ? index - 1 : index;

  static TabItem fromNavigationIndex(int index) {
    return TabItem.values.firstWhere(
      (tab) => tab != TabItem.main && tab.navigationIndex == index,
      orElse: () => TabItem.main,
    );
  }

  String get baseRouteLocation => switch (this) {
        TabItem.feed => FeedRoute().location,
        TabItem.chat => ChatRoute().location,
        TabItem.wallet => WalletRoute().location,
        TabItem.profile => SelfProfileRoute().location,
        TabItem.main => '/',
      };

  String get mainModalLocation => switch (this) {
        TabItem.feed || TabItem.profile => FeedMainModalRoute().location,
        TabItem.chat => ChatMainModalRoute().location,
        TabItem.wallet => WalletMainModalRoute().location,
        TabItem.main => '/',
      };
}
