import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/apps.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/categories.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/favourites.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/featured.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
import 'package:ice/app/shared/widgets/wallet_header/wallet_header.dart';

class DAppsPage extends IceSimplePage {
  const DAppsPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, _, __) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: context.theme.appColors.secondaryBackground),
        child: Column(
          children: <Widget>[
            const WalletHeader(),
            const Featured(),
            const Categories(),
            Apps(
              title: 'Highest ranked',
              items: featured,
              onPress: () {
                context.goNamed(IceRoutes.appsList.name);
              },
            ),
            Apps(
              title: 'Recently added',
              items: featured,
              onPress: () {
                context.goNamed(IceRoutes.appsList.name);
              },
            ),
            const Favourites(),
          ],
        ),
      ),
    );
  }
}
