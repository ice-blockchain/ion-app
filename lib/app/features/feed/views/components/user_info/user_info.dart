// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';

class UserInfo extends HookConsumerWidget {
  const UserInfo({
    required this.pubkey,
    this.trailing,
    this.textStyle,
    super.key,
  });

  final String pubkey;
  final Widget? trailing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));

    return userMetadata.maybeWhen(
      data: (userMetadataEntity) {
        if (userMetadataEntity == null) {
          return const SizedBox.shrink();
        }
        return ListItem.user(
          onTap: () => ProfileRoute(pubkey: pubkey).push<void>(context),
          title: Text(
            userMetadataEntity.data.displayName,
            style: textStyle,
          ),
          subtitle: Text(
            prefixUsername(username: userMetadataEntity.data.name, context: context),
            style: textStyle,
          ),
          profilePicture: userMetadataEntity.data.picture,
          trailing: trailing,
        );
      },
      orElse: () => const Skeleton(child: ListItemUserShape()),
    );
  }
}
