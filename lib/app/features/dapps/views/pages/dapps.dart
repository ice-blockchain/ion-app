import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/categories/featured.dart';
import 'package:ice/app/features/dapps/views/components/categories/categories.dart';
import 'package:ice/app/features/dapps/views/components/favourites/favourites.dart';
import 'package:ice/app/features/dapps/views/components/wallet_header/wallet_header.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/router/app_routes.dart';

class DAppsPage extends IceSimplePage {
  const DAppsPage(super.route, super.payload);
  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            const WalletHeader(),
            const Featured(),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 10.0,
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
    );
  }
}
