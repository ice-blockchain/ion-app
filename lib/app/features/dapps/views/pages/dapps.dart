// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/providers/dapps_provider.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/categories/featured.dart';
import 'package:ice/app/features/dapps/views/components/categories/categories.dart';
import 'package:ice/app/features/dapps/views/components/favourites/favourites.dart';
import 'package:ice/app/features/dapps/views/components/wallet_header/wallet_header.dart';
import 'package:ice/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class DAppsPage extends HookConsumerWidget {
  const DAppsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final apps = ref.watch(dappsDataProvider).valueOrNull ?? [];

    useScrollTopOnTabPress(context, scrollController: scrollController);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          CollapsingAppBar(
            height: WalletHeader.height,
            child: const WalletHeader(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Featured(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0.s, bottom: 7.0.s),
                  child: Container(
                    height: 10.0.s,
                    color: context.theme.appColors.primaryBackground,
                  ),
                ),
                const Categories(),
                Apps(
                  title: context.i18n.dapps_section_title_highest_ranked,
                  items: apps,
                  onPress: () {
                    DAppsListRoute(
                      $extra: AppsRouteData(
                        title: context.i18n.dapps_section_title_highest_ranked,
                      ),
                    ).push<void>(context);
                  },
                ),
                Apps(
                  title: context.i18n.dapps_section_title_recently_added,
                  items: apps,
                  topOffset: 8.0.s,
                  onPress: () {
                    DAppsListRoute(
                      $extra: AppsRouteData(
                        title: context.i18n.dapps_section_title_recently_added,
                      ),
                    ).push<void>(context);
                  },
                ),
                Favourites(
                  onPress: () {
                    DAppsListRoute(
                      $extra: AppsRouteData(
                        title: context.i18n.dapps_section_title_favourites,
                      ),
                    ).push<void>(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
