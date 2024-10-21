// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

class ProfileAbout extends ConsumerWidget {
  const ProfileAbout({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutText = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.about ??
        'Read @America to understand why I’m supporting Donald #Trump for President';

    return SizedBox(
      width: double.infinity,
      child: Text(
        aboutText,
        textAlign: TextAlign.start,
        style: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
