// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/followers_you_know/followed_by_avatars.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/followers_you_know/followed_by_text.dart';
import 'package:ion/app/features/user/providers/followers_you_know_data_source_provider.c.dart';

class FollowersYouKnow extends ConsumerWidget {
  const FollowersYouKnow({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(followersYouKnowDataSourceProvider(pubkey));
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
        FollowedByText(pubkeys: pubkeys),
      ],
    );
  }
}
