// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/replying_to/replying_to.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';

class ReplyAuthorHeader extends ConsumerWidget {
  const ReplyAuthorHeader({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserMetadata = ref.watch(currentUserMetadataProvider).valueOrNull;
    final userMetadata = ref.watch(userMetadataProvider(pubkey)).valueOrNull;

    if (currentUserMetadata == null || userMetadata == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListItem.user(
          title: Text(currentUserMetadata.data.displayName),
          subtitle: Text(prefixUsername(username: currentUserMetadata.data.name, context: context)),
          profilePicture: currentUserMetadata.data.picture,
        ),
        SizedBox(height: 6.0.s),
        ReplyingTo(name: userMetadata.data.name),
      ],
    );
  }
}
