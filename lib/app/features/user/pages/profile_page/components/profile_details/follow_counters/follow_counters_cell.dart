// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/router/app_routes.c.dart';

class FollowCountersCell extends StatelessWidget {
  const FollowCountersCell({
    required this.pubkey,
    required this.usersNumber,
    required this.followType,
    super.key,
  });

  final String pubkey;
  final int usersNumber;
  final FollowType followType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (usersNumber > 0) {
          final pickedUserPubkey = await FollowListRoute(
            pubkey: pubkey,
            followType: followType,
          ).push<String>(context);

          if (pickedUserPubkey != null && context.mounted) {
            unawaited(
              ProfileRoute(pubkey: pickedUserPubkey).push<void>(context),
            );
          }
        }
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconAssetColored(
              followType.iconAsset,
              color: context.theme.appColors.primaryText,
              size: 16.0,
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
