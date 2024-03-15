import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildNavigationBar(context),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final List<Widget> children = _Tabs.values
        .map(
          (_Tabs tab) => _convertToWidget(
            tab,
            context,
          ),
        )
        .toList();

    children.insert((children.length / 2).ceil(), _buildMainButton());

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

  Widget _convertToWidget(_Tabs tab, BuildContext context) {
    final StatefulShellBranch branch = _byTab(tab);
    final int branchIndex = navigationShell.route.branches.indexOf(branch);
    final bool selected = navigationShell.currentIndex == branchIndex;
    final Color color = selected
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

  Widget _buildMainButton() {
    return _buildHitBox(
      onTap: () {},
      child: Assets.images.logo.logoButton.image(height: 50.0.s),
    );
  }

  Widget _buildHitBox({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: Colors
            .transparent, // A hack to push the box for maximum boundaries yet having flex parent
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

enum _Tabs {
  feed(IceRoutes.feed),
  chat(IceRoutes.chat),
  dapps(IceRoutes.dapps),
  wallet(IceRoutes.wallet);

  const _Tabs(this.route);

  final IceRoutes<dynamic> route;

  AssetGenImage get icon {
    return switch (this) {
      _Tabs.feed => Assets.images.icons.iconHomeOff,
      _Tabs.chat => Assets.images.icons.iconChatOff,
      _Tabs.dapps => Assets.images.icons.iconDappOff,
      _Tabs.wallet => Assets.images.icons.iconsWalletOff,
    };
  }
}
