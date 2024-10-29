// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/follow_button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';

class CreatorListItem extends ConsumerWidget {
  const CreatorListItem({
    required this.pubkey,
    required this.onPressed,
    required this.selected,
    super.key,
  });

  final String pubkey;

  final VoidCallback onPressed;

  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));

    return userMetadata.maybeWhen(
      data: (userMetadataEntity) {
        if (userMetadataEntity == null) {
          return const SizedBox.shrink();
        }
        return ScreenSideOffset.small(
          child: ListItem.user(
            title: Text(userMetadataEntity.data.displayName),
            subtitle:
                Text(prefixUsername(username: userMetadataEntity.data.name, context: context)),
            profilePicture: userMetadataEntity.data.picture,
            verifiedBadge: userMetadataEntity.data.verified,
            ntfAvatar: userMetadataEntity.data.nft,
            backgroundColor: context.theme.appColors.tertararyBackground,
            contentPadding: EdgeInsets.all(12.0.s),
            borderRadius: BorderRadius.circular(16.0.s),
            trailing: FollowButton(onPressed: onPressed, following: selected),
            trailingPadding: EdgeInsets.only(left: 6.0.s),
          ),
        );
      },
      orElse: () => ScreenSideOffset.small(child: Skeleton(child: ListItem())),
    );
  }
}
