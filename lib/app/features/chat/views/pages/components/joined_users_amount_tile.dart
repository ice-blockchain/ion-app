// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/providers/community_members_count_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class JoinedUsersAmountTile extends HookConsumerWidget {
  const JoinedUsersAmountTile({
    required this.channelUUID,
    super.key,
  });

  final String channelUUID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(communityMembersCountProvider(channelUUID)).valueOrNull ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.0.s),
          child: Assets.svg.iconChannelMembers.icon(
            size: 10.0.s,
            color: context.theme.appColors.quaternaryText,
          ),
        ),
        SizedBox(
          width: 3.0.s,
        ),
        Text(
          amount.toString(),
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
        ),
      ],
    );
  }
}
