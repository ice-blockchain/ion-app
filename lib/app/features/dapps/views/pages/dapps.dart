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
import 'package:ice/app/components/wallet_header/wallet_header.dart';

class DAppsPage extends HookConsumerWidget {
  const DAppsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = GoRouter.of(context);

    return SingleChildScrollView(
      child: Container(
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
                router.go(
                  '/dapps/appsList',
                  extra: AppsRouteData(
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
                router.go(
                  '/dapps/appsList',
                  extra: AppsRouteData(
                    title: context.i18n.dapps_section_title_recently_added,
                    items: featured,
                  ),
                );
              },
            ),
            Favourites(
              onPress: () {
                router.go(
                  '/dapps/appsList',
                  extra: AppsRouteData(
                    title: context.i18n.dapps_section_title_favourites,
                    items: featured,
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
