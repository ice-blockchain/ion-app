import 'package:flutter/material.dart';
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

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final double leftOffset = index == 0 ? 16.0.s : 8.0.s;
          final double rightOffset =
              index == categories.length - 1 ? 16.0.s : 8.0.s;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  IceRoutes.appsList.go(
                    context,
                    payload: AppsRouteData(
                      title: categories[index].title,
                      items: mockedApps,
                      isSearchVisible: true,
                    ),
                  );
                },
                child: Container(
                  width: itemWidth,
                  height: itemWidth,
                  margin: EdgeInsets.only(right: rightOffset, left: leftOffset),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.6.s),
                    color: context.theme.appColors.tertararyBackground,
                    border: Border.all(
                      color: context.theme.appColors.onTerararyFill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        categories[index].iconImage,
                        width: 50.0.s,
                      ),
                    ],
                  ),
                ),
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
    );
  }
}
