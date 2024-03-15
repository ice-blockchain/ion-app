import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class ScaffoldWithNestedNavigation extends ConsumerWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
          key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'),
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
    final List<Widget> children = _Tabs.values.map((_Tabs tab) {
      final StatefulShellBranch branch = _byTab(tab);
      final int branchIndex = navigationShell.route.branches.indexOf(branch);
      final bool isSelected = navigationShell.currentIndex == branchIndex;

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
        color: context.theme.appColors.onPrimaryAccent,
        boxShadow: <BoxShadow>[
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
    final Color color = isSelected
        ? context.theme.appColors.primaryAccent
        : context.theme.appColors.tertararyText;

    return _buildHitBox(
      onTap: () => _goBranch(branchIndex),
      child: tab.icon.icon(color: color, size: 24.0.s),
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
    final IceRoutes<dynamic> current = ref.watch(currentRouteProvider);
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
    bool ripple = true,
    required VoidCallback onTap,
    required Widget child,
  }) {
    final Widget content = ColoredBox(
      color: Colors
          .transparent, // A hack to push the box for maximum boundaries yet having flex parent
      child: Center(
        child: child,
      ),
    );

    if (ripple) {
      return Material(
        child: InkWell(
          onTap: onTap,
          child: content,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}

enum _Tabs {
  feed(IceRoutes.feed, IceRoutes.feedMainModal),
  chat(IceRoutes.chat, IceRoutes.chatMainModal),
  dapps(IceRoutes.dapps, IceRoutes.dappsMainModal),
  wallet(IceRoutes.wallet, IceRoutes.walletMainModal);

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
