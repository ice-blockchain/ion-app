// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({
    required this.pubkey,
    required this.avatarSize,
    super.key,
  });

  final String pubkey;

  final double avatarSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPicture = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.data.picture;

    return GestureDetector(
      onTap: () => ProfileRoute(pubkey: pubkey).push<void>(context),
      child: Avatar(
        size: avatarSize,
        fit: BoxFit.cover,
        imageUrl: userPicture,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
    );
  }
}
