import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/components/apps.dart';
import 'package:ice/app/features/dapps/views/components/categories.dart';
import 'package:ice/app/features/dapps/views/components/favourites.dart';
import 'package:ice/app/features/dapps/views/components/featured.dart';
import 'package:ice/app/features/dapps/views/components/wallet_header/wallet_header.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_handler.dart';
import 'package:ice/app/router/app_routes.dart';

class DAppsPage extends IceSimplePage {
  const DAppsPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return PullRightMenuHandler(
      child: SingleChildScrollView(
        child: DecoratedBox(
          decoration:
              BoxDecoration(color: context.theme.appColors.secondaryBackground),
          child: Column(
            children: <Widget>[
              const WalletHeader(),
              const Featured(),
              const Categories(),
              Apps(
                title: context.i18n.dapps_section_title_highest_ranked,
                items: featured,
                onPress: () {
                  IceRoutes.appsList.go(
                    context,
                    payload: AppsRouteData(
                      title: context.i18n.dapps_section_title_highest_ranked,
                      items: featured,
                    ),
                  );
                },
              ),
              Apps(
                title: context.i18n.dapps_section_title_recently_added,
                items: featured,
                onPress: () {
                  IceRoutes.appsList.go(
                    context,
                    payload: AppsRouteData(
                      title: context.i18n.dapps_section_title_recently_added,
                      items: featured,
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
                      items: featured,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
