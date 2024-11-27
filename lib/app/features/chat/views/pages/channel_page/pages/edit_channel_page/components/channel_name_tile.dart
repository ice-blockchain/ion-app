// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/channels_provider.dart';
import 'package:ion/app/features/chat/views/pages/components/joined_users_amount_tile.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelNameTile extends ConsumerWidget {
  const ChannelNameTile({
    required this.pubkey,
    super.key,
  });

  double get verifiedIconSize => 16.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelData = ref.watch(channelsProvider.select((channelMap) => channelMap[pubkey]));

    if (channelData == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                textAlign: TextAlign.center,
                channelData.name,
                style: context.theme.appTextThemes.title.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
            ),
            if ((channelData.isVerified ?? false) == true) ...[
              SizedBox(width: 6.0.s),
              Assets.svg.iconBadgeVerify.icon(size: verifiedIconSize),
            ],
          ],
        ),
        SizedBox(height: 3.0.s),
        JoinedUsersAmountTile(
          amount: channelData.users.length,
        ),
      ],
    );
  }
}
