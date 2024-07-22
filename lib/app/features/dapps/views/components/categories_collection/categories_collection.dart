import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

enum DAppsCategory {
  defi,
  marketplaces,
  nft,
  games,
  social,
  utilities,
  other;

  Widget get icon {
    return switch (this) {
      DAppsCategory.defi => Assets.images.categories.categoriesDefi,
      DAppsCategory.marketplaces => Assets.images.categories.categoriesMarketplace,
      DAppsCategory.nft => Assets.images.categories.categoriesNft,
      DAppsCategory.games => Assets.images.categories.categoriesGames,
      DAppsCategory.social => Assets.images.categories.categoriesSocial,
      DAppsCategory.utilities => Assets.images.categories.categoriesUtilites,
      DAppsCategory.other => Assets.images.categories.categoriesOther,
    }
        .icon(size: 50.0.s);
  }

  String title(BuildContext context) {
    return switch (this) {
      DAppsCategory.defi => context.i18n.dapps_category_defi,
      DAppsCategory.marketplaces => context.i18n.dapps_category_marketplaces,
      DAppsCategory.nft => context.i18n.core_nfts,
      DAppsCategory.games => context.i18n.dapps_category_games,
      DAppsCategory.social => context.i18n.dapps_category_social,
      DAppsCategory.utilities => context.i18n.dapps_category_utilities,
      DAppsCategory.other => context.i18n.dapps_category_other,
    };
  }
}

class CategoriesCollection extends StatelessWidget {
  const CategoriesCollection({super.key});

  static double get itemWidth => 80.0.s;

  static double get itemHeight => 104.0.s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.s, top: 3.0.s),
      child: SizedBox(
        height: itemHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (BuildContext context, int index) => SizedBox(width: 15.0.s),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSideOffset.defaultSmallMargin,
          ),
          itemCount: DAppsCategory.values.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button.icon(
                  onPressed: () {
                    DAppsListRoute(
                      $extra: AppsRouteData(
                        title: DAppsCategory.values[index].title(context),
                        items: mockedApps,
                      ),
                    ).push<void>(context);
                  },
                  icon: DAppsCategory.values[index].icon,
                  size: itemWidth,
                  type: ButtonType.outlined,
                  backgroundColor: context.theme.appColors.tertararyBackground,
                  borderColor: context.theme.appColors.onTerararyFill,
                  borderRadius: BorderRadius.circular(12.0.s),
                ),
                Text(
                  DAppsCategory.values[index].title(context),
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
