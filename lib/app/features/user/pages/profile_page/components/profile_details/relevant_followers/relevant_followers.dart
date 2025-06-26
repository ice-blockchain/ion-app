// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/relevant_followers/followed_by_avatars.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/relevant_followers/followed_by_text.dart';
import 'package:ion/app/features/user/providers/relevant_followers_data_source_provider.r.dart';

class RelevantFollowers extends ConsumerWidget {
  const RelevantFollowers({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(relevantFollowersDataSourceProvider(pubkey));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items;

    if (entities == null || entities.isEmpty) {
      return const SizedBox.shrink();
    }

    final pubkeys = entities.take(3).map((entity) => entity.masterPubkey).toList();

    return Row(
      children: [
        FollowedByAvatars(pubkeys: pubkeys),
        SizedBox(width: 10.0.s),
        FollowedByText(
          pubkey: pubkey,
          firstFollowerPubkey: pubkeys.first,
          isMoreFollowers: pubkeys.length > 1,
        ),
      ],
    );
  }
}
