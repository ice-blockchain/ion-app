// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/pages/feed_simple_search_page/components/search_results/feed_search_results_list_item.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';

class FeedSearchResults extends ConsumerWidget {
  const FeedSearchResults({
    required this.users,
    super.key,
  });

  static double get listVerticalOffset => 14.0.s;

  final List<UserMetadataEntity> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: listVerticalOffset),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return FeedSearchResultsListItem(user: users[index]);
        },
      ),
    );
  }
}
