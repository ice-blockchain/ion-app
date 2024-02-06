import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

const double textContainerHeight = 24.0;

class CategoryItem {
  CategoryItem({
    required this.iconImage,
    required this.title,
  });

  final String iconImage;
  final String title;
}

List<CategoryItem> featured = <CategoryItem>[
  CategoryItem(
    iconImage: Assets.images.defi.path,
    title: 'DeFi',
  ),
  CategoryItem(
    iconImage: Assets.images.marketplace.path,
    title: 'Marketplaces',
  ),
  CategoryItem(
    iconImage: Assets.images.nft.path,
    title: 'NFTs',
  ),
  CategoryItem(
    iconImage: Assets.images.games.path,
    title: 'Games',
  ),
];

class CategoriesCollection extends StatelessWidget {
  const CategoriesCollection({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth * 0.213;
    final double itemHeight = itemWidth + textContainerHeight;

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featured.length,
        itemBuilder: (BuildContext context, int index) {
          final double leftOffset = index == 0 ? 16.0 : 8.0;
          final double rightOffset = index == featured.length - 1 ? 16.0 : 8.0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: itemWidth,
                height: itemWidth,
                margin: EdgeInsets.only(right: rightOffset, left: leftOffset),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.6),
                  color: context.theme.appColors.tertararyBackground,
                  border: Border.all(
                    color: context.theme.appColors.onTerararyFill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      featured[index].iconImage,
                      width: 50,
                    ),
                  ],
                ),
              ),
              Text(
                featured[index].title,
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
