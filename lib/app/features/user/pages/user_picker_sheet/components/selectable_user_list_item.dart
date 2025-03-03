// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectableUserListItem extends ConsumerWidget {
  const SelectableUserListItem({
    required this.pubkey,
    required this.masterPubkey,
    required this.onUserSelected,
    super.key,
    this.selectedPubkeys = const [],
    this.selectable = false,
  });

  final String pubkey;
  final String masterPubkey;
  final void Function(UserMetadataEntity user) onUserSelected;
  final List<String> selectedPubkeys;
  final bool selectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataResult = ref.watch(userMetadataProvider(masterPubkey));

    return userMetadataResult.maybeWhen(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        final isSelected =
            selectedPubkeys.contains(masterPubkey) || (selectedPubkeys.contains(pubkey));

        return ListItem.user(
          onTap: () => onUserSelected(user),
          title: Text(user.data.displayName),
          subtitle: Text(prefixUsername(username: user.data.name, context: context)),
          profilePicture: user.data.picture,
          contentPadding: EdgeInsets.symmetric(
              vertical: 8.0.s, horizontal: ScreenSideOffset.defaultSmallMargin),
          trailing: selectable
              ? isSelected
                  ? Assets.svg.iconBlockCheckboxOnblue.icon(
                      color: context.theme.appColors.success,
                    )
                  : Assets.svg.iconBlockCheckboxOff.icon(
                      color: context.theme.appColors.onTerararyFill,
                    )
              : null,
        );
      },
      orElse: SizedBox.shrink,
    );
  }
}
