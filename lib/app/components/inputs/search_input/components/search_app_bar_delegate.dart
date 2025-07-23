// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';

class SearchAppBarDelegate extends SliverPersistentHeaderDelegate {
  SearchAppBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => SearchInput.height;

  @override
  double get maxExtent => SearchInput.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
