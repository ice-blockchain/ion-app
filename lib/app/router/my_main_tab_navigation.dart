import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/my_app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class MainTabNavigation extends StatelessWidget {
  const MainTabNavigation({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const disabledTabs = <_Tabs>[
    _Tabs.chat,
    _Tabs.dapps,
    _Tabs.wallet,
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildNavigationBar(context),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Container(
      height: 82.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: context.theme.appColors.darkBlue.withOpacity(0.05),
            blurRadius: 16.0.s,
            offset: Offset(-2.0.s, -2.0.s),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 9.0.s, bottom: 23.0.s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _Tabs.values.map((_Tabs tab) {
            final branchIndex = _Tabs.values.indexOf(tab);
            final isSelected = navigationShell.currentIndex == branchIndex;

            final color = isSelected
                ? context.theme.appColors.primaryAccent
                : context.theme.appColors.tertararyText;

            return Flexible(
              child: _buildHitBox(
                onTap: () => _onTap(branchIndex),
                child: tab.icon.icon(color: color, size: 24.0.s),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHitBox({
    required VoidCallback onTap,
    required Widget child,
    bool ripple = true,
  }) {
    return ripple
        ? SizedBox.expand(
            child: IconButton(
              onPressed: onTap,
              icon: child,
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: SizedBox.expand(child: child),
          );
  }
}

enum _Tabs {
  feed(FeedRoute()),
  chat(ChatRoute()),
  dapps(DappsRoute()),
  wallet(WalletRoute());

  const _Tabs(this.route);

  final GoRouteData route;

  AssetGenImage get icon {
    return switch (this) {
      _Tabs.feed => Assets.images.icons.iconHomeOff,
      _Tabs.chat => Assets.images.icons.iconChatOff,
      _Tabs.dapps => Assets.images.icons.iconDappOff,
      _Tabs.wallet => Assets.images.icons.iconsWalletOff,
    };
  }
}
