import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/categories/featured.dart';
import 'package:ice/app/features/dapps/views/components/categories/categories.dart';
import 'package:ice/app/features/dapps/views/components/favourites/favourites.dart';
import 'package:ice/app/features/dapps/views/components/wallet_header/wallet_header.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';

class DAppsPage extends IceSimplePage {
  const DAppsPage(super.route, super.payload);
  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ScrollController scrollController = useScrollController();

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          FloatingAppBar(
            topOffset: 5.0.s,
            height: WalletHeader.height,
            child: const WalletHeader(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
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
                  items: mockedApps,
                  onPress: () {
                    IceRoutes.appsList.go(
                      context,
                      payload: AppsRouteData(
                        title: context.i18n.dapps_section_title_highest_ranked,
                        items: mockedApps,
                      ),
                    );
                  },
                ),
                Apps(
                  title: context.i18n.dapps_section_title_recently_added,
                  items: mockedApps,
                  onPress: () {
                    IceRoutes.appsList.go(
                      context,
                      payload: AppsRouteData(
                        title: context.i18n.dapps_section_title_recently_added,
                        items: mockedApps,
                      ),
                    );
                  },
                ),
                Favourites(
                  onPress: () {
                    IceRoutes.appsList.go(
                      context,
                      payload: AppsRouteData(
                        title: context.i18n.dapps_section_title_favourites,
                        items: <DAppItem>[],
                      ),
                    );
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
