// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectableUserListItem extends ConsumerWidget {
  const SelectableUserListItem({
    required this.pubkey,
    required this.isSelected,
    required this.onPress,
    super.key,
  });

  final String pubkey;
  final bool isSelected;
  final VoidCallback onPress;

  static double get itemHeight => 36.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataResult = ref.watch(userMetadataProvider(pubkey));

    return userMetadataResult.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) {
          return const SizedBox.shrink();
        }
        return ListItem.user(
          onTap: onPress,
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
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0.s, vertical: 0.0.s),
          constraints: BoxConstraints(minHeight: itemHeight),
          trailing: isSelected
              ? Assets.svg.iconBlockCheckboxOnblue.icon(
                  color: context.theme.appColors.success,
                )
              : Assets.svg.iconBlockCheckboxOff.icon(
                  color: context.theme.appColors.tertararyText,
                ),
        );
      },
      orElse: () => ItemLoadingState(
        itemHeight: itemHeight,
      ),
    );
  }
}
