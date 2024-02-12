import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/components/favourite_icon/favorite_icon.dart';
import 'package:ice/app/utils/extensions.dart';
import 'package:ice/app/values/constants.dart';

const double columnWidthPercentage = 0.68;
const double sectionHeight = 200.0;
const int itemsPerColumn = 3;

class AppsCollection extends StatelessWidget {
  const AppsCollection({super.key, this.items});

  final List<DAppItem>? items;

  @override
  Widget build(BuildContext context) {
    final List<DAppItem> itemList = items ?? <DAppItem>[];

    return SizedBox(
      height: sectionHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            children: List<Column>.generate(
              (itemList.length / itemsPerColumn).ceil(),
              (int columnIndex) {
                final int startIndex = columnIndex * itemsPerColumn;
                final int endIndex = (columnIndex + 1) * itemsPerColumn;
                return Column(
                  children: itemList
                      .getRange(startIndex, endIndex.clamp(0, itemList.length))
                      .map(
                        (DAppItem item) => SizedBox(
                          width: MediaQuery.of(context).size.width *
                              columnWidthPercentage,
                          child: DAppGridItem(item: item),
                        ),
                      )
                      .toList(),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class DAppGridItem extends StatelessWidget {
  const DAppGridItem({
    super.key,
    required this.item,
    this.showIsFavourite = false,
  });
  final DAppItem item;
  final bool showIsFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: kDefaultSidePadding,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  item.iconImage,
                  width: 48,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    item.title,
                    style: context.theme.appTextThemes.body.copyWith(
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                  Text(
                    item.description ?? '',
                    style: context.theme.appTextThemes.caption3.copyWith(
                      color: context.theme.appColors.secondaryText,
                    ),
                  ),
                  Text(
                    item.value != null ? formatDouble(item.value!) : '',
                    style: context.theme.appTextThemes.caption3.copyWith(
                      color: context.theme.appColors.tertararyText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showIsFavourite)
            FavouriteIcon(
              isFavourite: item.isFavourite,
            ),
        ],
      ),
    );
  }
}
