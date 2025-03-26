// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

class CurrentUserAvatar extends ConsumerWidget {
  const CurrentUserAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPicture = ref.watch(currentUserMetadataProvider).valueOrNull?.data.picture;
    return Avatar(size: 30.0.s, imageUrl: currentUserPicture);
  }
}
