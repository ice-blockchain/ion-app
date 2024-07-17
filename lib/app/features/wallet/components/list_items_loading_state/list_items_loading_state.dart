import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separated_column.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/num.dart';

class ListItemsLoadingState extends StatelessWidget {
  const ListItemsLoadingState({
    super.key,
  });

  static const int itemCount = 7;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 16.0.s),
      sliver: SliverToBoxAdapter(
        child: Skeleton(
          child: SeparatedColumn(
            separator: SizedBox(
              height: 12.0.s,
            ),
            children: List.generate(
              itemCount,
              (int i) => ScreenSideOffset.small(child: ListItem()),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
