// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class FollowCountersCell extends ConsumerWidget {
  const FollowCountersCell({
    required this.pubkey,
    required this.followType,
    super.key,
  });

  final String pubkey;
  final FollowType followType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersNumber = followType == FollowType.following
        ? ref.watch(followListProvider(pubkey)).valueOrNull?.data.list.length
        : ref.watch(followersCountProvider(pubkey: pubkey)).valueOrNull;

    if (usersNumber == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        if (usersNumber > 0) {
          FollowListRoute(
            pubkey: pubkey,
            followType: followType,
          ).push<String>(context);
        }
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            followType.iconAsset.icon(
              color: context.theme.appColors.primaryText,
              size: 16.0.s,
            ),
            SizedBox(width: 4.0.s),
            Text(
              '$usersNumber',
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            SizedBox(width: 4.0.s),
            Text(
              followType.getTitle(context),
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.tertararyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
