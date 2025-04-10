// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_list_item_shape.dart';

class ChatSearchResultsSkeleton extends StatelessWidget {
  const ChatSearchResultsSkeleton({super.key});

  static const int numberOfItems = 5;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.0.s),
        child: Column(
          children: List.generate(
            numberOfItems,
            (_) => ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: const ChatSearchListItemShape(),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}
