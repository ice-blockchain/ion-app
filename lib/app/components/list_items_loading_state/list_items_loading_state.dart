// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/num.dart';

class ListItemsLoadingState extends StatelessWidget {
  const ListItemsLoadingState({
    required this.itemsCount,
    required this.itemHeight,
    super.key,
  });

  final int itemsCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 16.0.s),
      sliver: SliverToBoxAdapter(
        child: Skeleton(
          child: SeparatedColumn(
            separator: SizedBox(
              height: itemHeight,
            ),
            children: List.generate(
              itemsCount,
              (_) => ScreenSideOffset.small(child: ListItem()),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
