import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/num.dart';

class TransactionListLoadingState extends StatelessWidget {
  const TransactionListLoadingState({
    super.key,
  });

  static const int itemCount = 7;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 16.0.s),
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 12.0.s,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ScreenSideOffset.small(
            child: Skeleton(
              child: ListItem(),
            ),
          );
        },
      ),
    );
  }
}
