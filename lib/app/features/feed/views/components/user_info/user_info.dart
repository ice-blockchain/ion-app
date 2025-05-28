// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/badges_user_list_item.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_avatar/ion_connect_avatar.dart';
import 'package:ion/app/features/feed/views/components/time_ago/time_ago.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';

class UserInfo extends HookConsumerWidget {
  const UserInfo({
    required this.pubkey,
    this.trailing,
    this.textStyle,
    this.createdAt,
    this.accentTheme = false,
    this.timeFormat = TimestampFormat.short,
    super.key,
  });

  final String pubkey;
  final bool accentTheme;
  final Widget? trailing;
  final TextStyle? textStyle;
  final int? createdAt;
  final TimestampFormat timeFormat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));
    void openProfile() => ProfileRoute(pubkey: pubkey).push<void>(context);

    return userMetadata.maybeWhen(
      data: (userMetadataEntity) {
        if (userMetadataEntity == null) {
          return const SizedBox.shrink();
        }
        return BadgesUserListItem(
          title: GestureDetector(
            onTap: openProfile,
            child: Text(
              userMetadataEntity.data.displayName,
              style: textStyle,
            ),
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: openProfile,
                child: Text(
                  prefixUsername(username: userMetadataEntity.data.name, context: context),
                  style: textStyle,
                ),
              ),
              if (createdAt != null) ...[
                SizedBox(width: 4.0.s),
                Text('•', style: textStyle),
                SizedBox(width: 4.0.s),
                TimeAgo(
                  time: createdAt!.toDateTime,
                  timeFormat: timeFormat,
                  style: textStyle,
                ),
              ],
            ],
          ),
          pubkey: pubkey,
          leading: GestureDetector(
            onTap: openProfile,
            child: IonConnectAvatar(
              size: ListItem.defaultAvatarSize,
              pubkey: pubkey,
            ),
          ),
          trailing: trailing,
          trailingPadding: EdgeInsetsDirectional.only(start: 34.0.s),
        );
      },
      orElse: () => Skeleton(
        child: ListItemUserShape(color: accentTheme ? Colors.white.withValues(alpha: 0.1) : null),
      ),
    );
  }
}
