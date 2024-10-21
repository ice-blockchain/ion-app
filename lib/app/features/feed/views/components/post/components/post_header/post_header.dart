// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/username.dart';

class PostHeader extends ConsumerWidget {
  const PostHeader({
    required this.pubkey,
    super.key,
    this.trailing,
  });

  final Widget? trailing;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));

    return Padding(
      padding: EdgeInsets.only(top: 12.0.s, bottom: 10.0.s),
      child: userMetadata.maybeWhen(
        data: (userMetadata) {
          if (userMetadata == null) {
            return const SizedBox.shrink();
          }
          return ListItem.user(
            onTap: () => FeedProfileRoute(pubkey: pubkey).push<void>(context),
            title: Text(userMetadata.displayName),
            subtitle: Text(prefixUsername(username: userMetadata.name, context: context)),
            profilePicture: userMetadata.picture,
            trailing: trailing,
            iceBadge: Random().nextBool(),
            verifiedBadge: Random().nextBool(),
            ntfAvatar: Random().nextBool(),
          );
        },
        orElse: () => const Skeleton(child: ListItemUserShape()),
      ),
    );
  }
}
