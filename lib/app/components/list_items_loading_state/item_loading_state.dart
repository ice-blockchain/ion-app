// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';

class ItemLoadingState extends StatelessWidget {
  const ItemLoadingState({
    this.itemHeight,
    this.paddingHorizontal = 0,
    super.key,
  });

  final double? itemHeight;
  final double paddingHorizontal;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: ListItem(
          constraints: itemHeight != null ? BoxConstraints(minHeight: itemHeight!) : null,
        ),
      ),
    );
  }
}
