// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';

class UseListItem extends ConsumerWidget {
  const UseListItem({
    required this.pubkey,
    required this.minHeight,
    super.key,
  });

  final String pubkey;
  final double minHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataResult = ref.watch(userMetadataProvider(pubkey));

    return userMetadataResult.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) {
          return const SizedBox.shrink();
        }
        return ListItem.user(
          title: Text(userMetadata.data.displayName),
          subtitle: Text(
            prefixUsername(
              username: userMetadata.data.name,
              context: context,
            ),
          ),
          profilePicture: userMetadata.data.picture,
          constraints: BoxConstraints(maxHeight: minHeight, minHeight: minHeight),
        );
      },
      orElse: () => ItemLoadingState(
        itemHeight: minHeight,
      ),
    );
  }
}
