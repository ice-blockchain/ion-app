// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat-v2/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_members_count_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class CommunityMemberCountTile extends HookConsumerWidget {
  const CommunityMemberCountTile({
    required this.community,
    super.key,
  });

  final CommunityDefinitionEntity community;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(communityMembersCountProvider(community)).valueOrNull;

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
        Padding(
          padding: EdgeInsets.only(left: 3.0.s),
          child: Text(
            count?.toString() ?? '',
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.quaternaryText,
            ),
          ),
        ),
      ],
    );
  }
}
