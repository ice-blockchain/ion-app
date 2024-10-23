// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatAdvancedSearchUserListItem extends ConsumerWidget {
  const ChatAdvancedSearchUserListItem({
    required this.pubKey,
    super.key,
  });

  final String pubKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataValue = ref.watch(userMetadataProvider(pubKey)).valueOrNull;

    if (userMetadataValue == null) {
      return const SizedBox.shrink();
    }

    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(
                imageUrl: userMetadataValue.picture,
                size: 40.0.s,
              ),
              SizedBox(width: 12.0.s),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userMetadataValue.displayName,
                        style: context.theme.appTextThemes.subtitle3,
                      ),
                      SizedBox(width: 4.0.s),
                      if (userMetadataValue.verified)
                        Padding(
                          padding: EdgeInsets.only(left: 4.0.s),
                          child: Assets.svg.iconBadgeIcelogo.icon(size: 16),
                        ),
                      if (userMetadataValue.verified)
                        Padding(
                          padding: EdgeInsets.only(left: 4.0.s),
                          child: Assets.svg.iconBadgeVerify.icon(size: 16),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.0.s),
                  Text(
                    prefixUsername(username: userMetadataValue.name, context: context),
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.onTertararyBackground,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Assets.svg.iconArrowRight
                  .icon(size: 24.0.s, color: context.theme.appColors.tertararyText),
            ],
          ),
        ],
      ),
    );
  }
}
