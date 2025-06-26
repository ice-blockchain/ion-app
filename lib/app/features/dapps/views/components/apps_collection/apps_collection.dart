// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/dapps/model/dapp_data.f.dart';
import 'package:ion/app/features/dapps/views/components/grid_item/grid_item.dart';

class AppsCollection extends StatelessWidget {
  const AppsCollection({super.key, this.items});

  final List<DAppData>? items;

  static double get itemWidth => 255.0.s;
  static double get offsetBetweenItems => 16.0.s;
  static double get itemHeight => 54.0.s;
  static const int itemsPerColumn = 3;
  static const double containerAspectRatio = 0.235;

  @override
  Widget build(BuildContext context) {
    final itemList = items ?? <DAppData>[];

    return SizedBox(
      height: itemHeight * itemsPerColumn + offsetBetweenItems * (itemsPerColumn - 1),
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        crossAxisCount: itemsPerColumn,
        childAspectRatio: containerAspectRatio,
        children: itemList
            .map(
              (item) => SizedBox(
                width: itemWidth,
                height: itemHeight,
                child: GridItem(dAppData: item),
              ),
            )
            .toList(),
      ),
    );
  }
}
