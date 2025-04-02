// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    this.padding,
    super.key,
  });

  final int? itemsCount;
  final double? itemHeight;
  final double? separatorHeight;
  final EdgeInsetsGeometry? padding;
  final ListItemsLoadingStateType listItemsLoadingStateType;

  @override
  Widget build(BuildContext context) {
    final skeleton = _Skeleton(
      itemsCount: itemsCount,
      itemHeight: itemHeight,
      separatorHeight: separatorHeight,
    );
    switch (listItemsLoadingStateType) {
      case ListItemsLoadingStateType.listView:
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: skeleton,
        );
      case ListItemsLoadingStateType.scrollView:
        return SliverPadding(
          padding: padding ?? EdgeInsetsDirectional.only(top: 16.0.s),
          sliver: SliverToBoxAdapter(
            child: skeleton,
          ),
        );
    }
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({
    this.separatorHeight,
    this.itemHeight,
    this.itemsCount,
  });

  final double? separatorHeight;
  final double? itemHeight;
  final int? itemsCount;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        fit: OverflowBoxFit.deferToChild,
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
      ),
    );
  }
}
