import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/dapps/views/components/grid_item/grid_item.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';

class AppsCollection extends StatelessWidget {
  const AppsCollection({super.key, this.items});

  final List<DAppItem>? items;

  static double get itemWidth => 255.0.s;
  static double get itemHeight => 54.0.s;
  static double get verticalOffset => 12.0.s;
  static int get itemsPerColumn => 3;

  @override
  Widget build(BuildContext context) {
    final List<DAppItem> itemList = items ?? <DAppItem>[];

    return SizedBox(
      height: itemHeight * itemsPerColumn + verticalOffset * itemsPerColumn,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        crossAxisCount: itemsPerColumn,
        childAspectRatio: itemHeight / itemWidth,
        children: itemList
            .map(
              (DAppItem item) => Container(
                color:
                    item.title == 'Uniswap' ? Colors.red : Colors.transparent,
                width: itemWidth,
                child: GridItem(item: item),
              ),
            )
            .toList(),
      ),
    );
  }
}
