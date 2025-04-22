// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';

class MentionItem extends ConsumerWidget {
  const MentionItem({
    required this.pubkey,
    required this.onPress,
    super.key,
  });

  final String pubkey;
  final ValueChanged<String> onPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));

    return userMetadata.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) {
          return const SizedBox.shrink();
        }
        final username = prefixUsername(username: userMetadata.data.name, context: context);
        return IntrinsicHeight(
          child: ListItem.user(
            onTap: () => onPress(username),
            title: Text(userMetadata.data.displayName),
            subtitle: Text(username),
            pubkey: pubkey,
          ),
        );
      },
      orElse: () => const Skeleton(child: ListItemUserShape()),
    );
  }
}
