// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/user/user_about/user_about.dart';
import 'package:ion/app/features/components/user/user_info_summary/user_info_summary.dart';
import 'package:ion/app/features/feed/views/components/delete_feed_item_menu/delete_feed_item_menu.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';

class UserBiography extends ConsumerWidget {
  const UserBiography({required this.entity, super.key});

  final CacheableEntity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwnedByCurrentUser = ref.watch(isCurrentUserSelectorProvider(entity.masterPubkey));

    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent,
        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
        border: Border.all(
          width: 1.0.s,
          color: context.theme.appColors.onTerararyFill,
        ),
      ),
      padding: EdgeInsets.all(
        12.0.s,
      ),
      child: Column(
        children: [
          UserInfo(
            pubkey: entity.masterPubkey,
            trailing: isOwnedByCurrentUser
                ? DeleteFeedItemMenu(
                    entity: entity,
                    onDelete: () {
                      context.pop();
                    },
                  )
                : UserInfoMenu(pubkey: entity.masterPubkey),
          ),
          SizedBox(height: 12.0.s),
          UserAbout(pubkey: entity.masterPubkey),
          SizedBox(height: 12.0.s),
          UserInfoSummary(pubkey: entity.masterPubkey),
        ],
      ),
    );
  }
}
