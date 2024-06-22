import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separated_column.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/constants/ui_size.dart';

class ListItemsLoadingState extends StatelessWidget {
  const ListItemsLoadingState({
    super.key,
  });

  static const int itemCount = 7;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: UiSize.medium),
      sliver: SliverToBoxAdapter(
        child: Skeleton(
          child: SeparatedColumn(
            separator: SizedBox(
              height: UiSize.small,
            ),
            children: List<Widget>.generate(
              itemCount,
              (int i) => ScreenSideOffset.small(child: ListItem()),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
