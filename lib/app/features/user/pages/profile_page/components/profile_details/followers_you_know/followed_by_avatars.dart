// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

class FollowedByAvatars extends StatelessWidget {
  const FollowedByAvatars({required this.pubkeys, super.key});

  final List<String> pubkeys;

  @override
  Widget build(BuildContext context) {
    final avatarSize = _FollowedAvatar.avatarSize;
    final overlap = avatarSize * 0.2;

    return SizedBox(
      height: avatarSize,
      width: avatarSize + (pubkeys.length - 1) * (avatarSize - overlap),
      child: Stack(
        children: [
          for (int i = pubkeys.length - 1; i >= 0; i--)
            Positioned(
              left: i * (avatarSize - overlap),
              child: _FollowedAvatar(pubkey: pubkeys[i]),
            ),
        ],
      ),
    );
  }
}

class _FollowedAvatar extends ConsumerWidget {
  const _FollowedAvatar({required this.pubkey});

  final String pubkey;

  static double get avatarSize => 20.0.s;

  double get borderWidth => 1.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // User metadata is fetched alongside the `followersYouKnowDataSourceProvider`, so don't fetch it manually
    final userMetadata = ref.watch(userMetadataProvider(pubkey, network: false)).valueOrNull;

    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0.s),
      ),
      child: Avatar(
        size: avatarSize - borderWidth * 2,
        fit: BoxFit.cover,
        imageUrl: userMetadata?.data.picture,
        borderRadius: BorderRadius.circular(6.0.s),
      ),
    );
  }
}
