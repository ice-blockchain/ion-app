// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/user/follow_user_button/follow_user_button.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/utils/username.dart';

class FollowListItem extends ConsumerWidget {
  const FollowListItem({
    required this.userMetadata,
    super.key,
  });

  final UserMetadataEntity? userMetadata;

  static double get itemHeight => 35.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (userMetadata == null) {
      return ItemLoadingState(itemHeight: itemHeight);
    }

    final UserMetadataEntity(:masterPubkey, :data) = userMetadata!;

    return ListItem.user(
      title: Text(data.name),
      trailing: FollowUserButton(pubkey: masterPubkey),
      subtitle: Text(
        prefixUsername(
          username: data.displayName,
          context: context,
        ),
      ),
      profilePicture: data.picture,
      onTap: () {
        Navigator.of(context).pop(masterPubkey);
      },
    );
  }
}
