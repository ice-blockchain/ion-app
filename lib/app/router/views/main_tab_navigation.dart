import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class MainTabNavigation extends ConsumerWidget {
  const MainTabNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(
          key: key ?? const ValueKey<String>('MainTabNavigation'),
        );
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildNavigationBar(context, ref),
    );
  }

  Widget _buildNavigationBar(BuildContext context, WidgetRef ref) {
    late final _Tabs selectedTab;
    final children = _Tabs.values.map((_Tabs tab) {
      final branch = _byTab(tab);
      final branchIndex = navigationShell.route.branches.indexOf(branch);
      final isSelected = navigationShell.currentIndex == branchIndex;

      if (isSelected) {
        selectedTab = tab;
      }

      return _convertToWidget(
        tab,
        branchIndex,
        isSelected,
        context,
      );
    }).toList();

    children.insert(
      (children.length / 2).ceil(),
      _buildMainButton(selectedTab, context, ref),
    );

    return Container(
      height: 82.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.theme.appColors.darkBlue.withOpacity(0.05),
            blurRadius: UiSize.medium,
            offset: Offset(-2.0.s, -2.0.s),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 9.0.s, bottom: 23.0.s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              children.map((Widget child) => Flexible(child: child)).toList(),
        ),
      ),
    );
  }

  Widget _convertToWidget(
    _Tabs tab,
    int branchIndex,
    bool isSelected,
    BuildContext context,
  ) {
    final color = isSelected
        ? context.theme.appColors.primaryAccent
        : context.theme.appColors.tertararyText;

    return _buildHitBox(
      onTap: () => _goBranch(branchIndex),
      child: tab.icon.icon(color: color, size: UiSize.large),
    );
  }

  StatefulShellBranch _byTab(_Tabs tab) {
    return navigationShell.route.branches.firstWhere(
      (StatefulShellBranch branch) =>
          (branch.routes.single as GoRoute).name == tab.route.routeName,
    );
  }

  Widget _buildMainButton(
    _Tabs selectedTab,
    BuildContext context,
    WidgetRef ref,
  ) {
    final current = ref.watch(currentRouteProvider);
    late final AssetGenImage image;
    if (_Tabs.values.map((_Tabs tab) => tab.mainModalRoute).contains(current)) {
      image = Assets.images.logo.logoButtonClose;
    } else {
      image = Assets.images.logo.logoButton;
    }

    return _buildHitBox(
      ripple: false,
      onTap: () {
        selectedTab.mainModalRoute.go(context);
      },
      child: image.image(height: 50.0.s), //TODO refactor into .icon when fixed
    );
  }

  Widget _buildHitBox({
    required VoidCallback onTap,
    required Widget child,
    bool ripple = true,
  }) {
    if (ripple) {
      return SizedBox.expand(
        child: IconButton(
          onPressed: onTap,
          icon: child,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.expand(child: child),
    );
  }
}

enum _Tabs {
  feed(IceRoutes.feed, IceRoutes.feedMainModal),
  chat(IceRoutes.chat, IceRoutes.chat),
  dapps(IceRoutes.dapps, IceRoutes.dapps),
  wallet(IceRoutes.wallet, IceRoutes.wallet);

  const _Tabs(this.route, this.mainModalRoute);

  final IceRoutes<dynamic> route;
  final IceRoutes<dynamic> mainModalRoute;

  AssetGenImage get icon {
    return switch (this) {
      _Tabs.feed => Assets.images.icons.iconHomeOff,
      _Tabs.chat => Assets.images.icons.iconChatOff,
      _Tabs.dapps => Assets.images.icons.iconDappOff,
      _Tabs.wallet => Assets.images.icons.iconsWalletOff,
    };
  }
}
