// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/data/models/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/followers_list.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/following_list.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/relevant_followers_list.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class FollowListView extends ConsumerWidget {
  const FollowListView({
    required this.followType,
    required this.pubkey,
    super.key,
  });

  final FollowType followType;
  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: switch (followType) {
        FollowType.following => FollowingList(pubkey: pubkey),
        FollowType.followers => FollowersList(pubkey: pubkey),
        FollowType.relevant => RelevantFollowersList(pubkey: pubkey),
      },
    );
  }
}
