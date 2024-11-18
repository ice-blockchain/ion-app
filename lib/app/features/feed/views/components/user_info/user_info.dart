// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/username.dart';

class UserInfo extends HookConsumerWidget {
  const UserInfo({
    required this.pubkey,
    super.key,
    this.trailing,
  });

  final Widget? trailing;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));
    final mockedIceBadge = useState(Random().nextBool());
    final mockedVerifiedBadge = useState(Random().nextBool());
    final mockedNtfAvatar = useState(Random().nextBool());

    return userMetadata.maybeWhen(
      data: (userMetadataEntity) {
        if (userMetadataEntity == null) {
          return const SizedBox.shrink();
        }
        return ListItem.user(
          onTap: () => ProfileRoute(pubkey: pubkey).push<void>(context),
          title: Text(userMetadataEntity.data.displayName),
          subtitle: Text(prefixUsername(username: userMetadataEntity.data.name, context: context)),
          profilePicture: userMetadataEntity.data.picture,
          trailing: trailing,
          iceBadge: mockedIceBadge.value,
          verifiedBadge: mockedVerifiedBadge.value,
          ntfAvatar: mockedNtfAvatar.value,
        );
      },
      orElse: () => const Skeleton(child: ListItemUserShape()),
    );
  }
}
