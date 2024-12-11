// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

class FollowingList extends ConsumerWidget {
  const FollowingList({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pubkeys = ref.watch(followListProvider(pubkey)).valueOrNull?.pubkeys;

    return CustomScrollView(
      slivers: [
        FollowAppBar(
          title: FollowType.following.getTitleWithCounter(context, pubkeys?.length ?? 0),
        ),
        const FollowSearchBar(),
        if (pubkeys != null)
          SliverList.separated(
            separatorBuilder: (_, __) => SizedBox(height: 16.0.s),
            itemCount: pubkeys.length,
            itemBuilder: (context, index) => _ListItem(pubkey: pubkeys[index]),
          )
        else
          const FollowListLoading(),
        SliverPadding(padding: EdgeInsets.only(bottom: 32.0.s)),
      ],
    );
  }
}

class _ListItem extends ConsumerWidget {
  const _ListItem({required this.pubkey});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    return ScreenSideOffset.small(
      child: FollowListItem(userMetadata: userMetadata),
    );
  }
}
