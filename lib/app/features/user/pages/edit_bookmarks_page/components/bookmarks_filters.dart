// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/bookmarks_page/components/bookmarks_filter_tile.dart';

class BookmarksFilters extends StatelessWidget {
  const BookmarksFilters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final filterNames = [context.i18n.core_all, 'Business', 'Crypto', 'Games'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.0.s, vertical: 12.0.s),
      child: Row(
        children: [
          for (final filterName in filterNames)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0.s),
              child: BookmarksFilterTile(
                title: filterName,
                isActive: filterName == context.i18n.core_all,
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}
