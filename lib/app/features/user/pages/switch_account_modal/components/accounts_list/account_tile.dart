// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class AccountsTile extends ConsumerWidget {
  const AccountsTile({
    required this.identityKeyName,
    super.key,
  });

  final String identityKeyName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
    final keyStore = ref.watch(nostrKeyStoreProvider(identityKeyName)).valueOrNull;

    if (keyStore == null) {
      return Skeleton(child: ListItem());
    }

    final userMetadataValue = ref.watch(userMetadataProvider(keyStore.publicKey)).valueOrNull;
    final isCurrentUser = identityKeyName == currentIdentityKeyName;

    if (userMetadataValue == null) {
      return Skeleton(child: ListItem());
    }

    return ListItem.user(
      isSelected: isCurrentUser,
      onTap: () {
        if (!isCurrentUser) {
          ref.read(authProvider.notifier).setCurrentUser(identityKeyName);
        }
      },
      title: Text(userMetadataValue.displayName),
      subtitle: Text(prefixUsername(username: userMetadataValue.name, context: context)),
      profilePicture: userMetadataValue.picture,
      trailing: isCurrentUser == true
          ? Assets.svg.iconBlockCheckboxOnblue.icon(color: context.theme.appColors.onPrimaryAccent)
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s),
      backgroundColor: context.theme.appColors.tertararyBackground,
      borderRadius: ListItem.defaultBorderRadius,
      constraints: ListItem.defaultConstraints,
    );
  }
}
