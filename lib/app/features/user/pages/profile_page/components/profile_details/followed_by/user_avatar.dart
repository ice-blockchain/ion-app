// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  static double get avatarSize => 20.0.s;

  double get borderWidth => 1.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPicture = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.picture;

    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0.s),
      ),
      child: Avatar(
        size: avatarSize - borderWidth * 2,
        fit: BoxFit.cover,
        imageUrl: userPicture,
        borderRadius: BorderRadius.circular(6.0.s),
      ),
    );
  }
}
