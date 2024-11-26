// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class GroupMemberListItem extends ConsumerWidget {
  const GroupMemberListItem({
    required this.isCurrentPubkey,
    required this.onRemove,
    required this.pubkey,
    super.key,
  });

  final String pubkey;
  final bool isCurrentPubkey;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataResult = ref.watch(userMetadataProvider(pubkey));

    return userMetadataResult.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) return const SizedBox.shrink();

        return ListItem.user(
          title: Text(userMetadata.data.displayName),
          subtitle: Text(
            prefixUsername(username: userMetadata.data.name, context: context),
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.sheetLine,
            ),
          ),
          profilePicture: userMetadata.data.picture,
          verifiedBadge: userMetadata.data.verified,
          ntfAvatar: userMetadata.data.nft,
          contentPadding: EdgeInsets.zero,
          constraints: BoxConstraints(maxHeight: 39.0.s),
          trailing: isCurrentPubkey
              ? null
              : GestureDetector(
                  onTap: onRemove,
                  behavior: HitTestBehavior.opaque,
                  child: Assets.svg.iconBlockDelete.icon(
                    size: 24.0.s,
                    color: context.theme.appColors.sheetLine,
                  ),
                ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
