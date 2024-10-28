// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class UserNameTile extends ConsumerWidget {
  const UserNameTile({
    required this.pubkey,
    super.key,
  });

  double get verifiedIconSize => 16.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataValue = ref.watch(userMetadataProvider(pubkey)).valueOrNull;

    if (userMetadataValue == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userMetadataValue.displayName,
              style: context.theme.appTextThemes.title.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            if (userMetadataValue.verified) ...[
              SizedBox(width: 6.0.s),
              Assets.svg.iconBadgeVerify.icon(size: verifiedIconSize),
            ],
          ],
        ),
        SizedBox(height: 3.0.s),
        Text(
          prefixUsername(username: userMetadataValue.name, context: context),
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
