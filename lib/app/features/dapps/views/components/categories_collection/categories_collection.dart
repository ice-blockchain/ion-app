import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class CategoryItem {
  CategoryItem({
    required this.iconImage,
    required this.title,
  });

  final String iconImage;
  final String title;
}

List<CategoryItem> getFeaturedCategories(BuildContext context) {
  return <CategoryItem>[
    CategoryItem(
      iconImage: Assets.images.categories.categoriesDefi.path,
      title: context.i18n.dapps_category_defi,
    ),
    CategoryItem(
      iconImage: Assets.images.categories.categoriesMarketplace.path,
      title: context.i18n.dapps_category_marketplaces,
    ),
    CategoryItem(
      iconImage: Assets.images.categories.categoriesNft.path,
      title: context.i18n.dapps_category_nft,
    ),
    CategoryItem(
      iconImage: Assets.images.categories.categoriesGames.path,
      title: context.i18n.dapps_category_games,
    ),
    CategoryItem(
      iconImage: Assets.images.categories.categoriesSocial.path,
      title: context.i18n.dapps_category_social,
    ),
    CategoryItem(
      iconImage: Assets.images.categories.categoriesUtilites.path,
      title: context.i18n.dapps_category_utilities,
    ),
    CategoryItem(
      iconImage: Assets.images.categories.categoriesOther.path,
      title: context.i18n.dapps_category_other,
    ),
  ];
}

class CategoriesCollection extends StatelessWidget {
  const CategoriesCollection({super.key});

  static double get itemWidth => 80.0.s;
  static double get itemHeight => 104.0.s;

  @override
  Widget build(BuildContext context) {
    final List<CategoryItem> categories = getFeaturedCategories(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: itemHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: ScreenSideOffset.defaultSmallMargin),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSideOffset.defaultSmallMargin,
          ),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Button.icon(
                  onPressed: () {
                    IceRoutes.appsList.go(
                      context,
                      payload: AppsRouteData(
                        title: categories[index].title,
                        items: mockedApps,
                        isSearchVisible: true,
                      ),
                    );
                  },
                  icon: Image.asset(
                    categories[index].iconImage,
                    width: 50.0.s,
                  ),
                  size: itemWidth,
                  type: ButtonType.outlined,
                  backgroundColor: context.theme.appColors.tertararyBackground,
                  borderColor: context.theme.appColors.onTerararyFill,
                ),
                Text(
                  categories[index].title,
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
