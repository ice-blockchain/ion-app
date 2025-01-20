// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/providers/community_members_count_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class JoinedUsersAmountTile extends HookConsumerWidget {
  const JoinedUsersAmountTile({
    required this.channelUuid,
    super.key,
  });

  final String channelUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(communityMembersCountProvider(channelUuid)).valueOrNull ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.svg.iconChannelMembers.icon(
          size: 10.0.s,
          color: context.theme.appColors.quaternaryText,
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
