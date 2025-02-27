// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatAdvancedSearchUserListItem extends ConsumerWidget {
  const ChatAdvancedSearchUserListItem({
    required this.user,
    super.key,
  });

  final UserMetadataEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0.s),
          Row(
            children: [
              Avatar(
                imageUrl: user.data.picture,
                size: 40.0.s,
              ),
              SizedBox(width: 12.0.s),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.data.displayName,
                        style: context.theme.appTextThemes.subtitle3,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.0.s),
                  Text(
                    prefixUsername(username: user.data.name, context: context),
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
          SizedBox(height: 8.0.s),
        ],
      ),
    );
  }
}
