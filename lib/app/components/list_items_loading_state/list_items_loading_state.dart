// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/num.dart';

enum ListItemsLoadingStateType {
  scrollView,
  listView,
}

class ListItemsLoadingState extends StatelessWidget {
  const ListItemsLoadingState({
    required this.listItemsLoadingStateType,
    this.itemsCount,
    this.itemHeight,
    this.separatorHeight,
    super.key,
  });

  final int? itemsCount;
  final double? itemHeight;
  final double? separatorHeight;
  final ListItemsLoadingStateType listItemsLoadingStateType;

  Widget _buildSkeleton({
    required BuildContext context,
  }) {
    return Skeleton(
      child: SeparatedColumn(
        separator: SizedBox(
          height: separatorHeight ?? 16.0.s,
        ),
        children: List.generate(
          itemsCount ?? 11,
          (_) => ItemLoadingState(
            paddingHorizontal: ScreenSideOffset.defaultSmallMargin,
            itemHeight: itemHeight,
          ),
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (listItemsLoadingStateType) {
      case ListItemsLoadingStateType.listView:
        return _buildSkeleton(context: context);
      case ListItemsLoadingStateType.scrollView:
        return SliverPadding(
          padding: EdgeInsets.only(top: 16.0.s),
          sliver: SliverToBoxAdapter(
            child: _buildSkeleton(context: context),
          ),
        );
    }
  }
}
