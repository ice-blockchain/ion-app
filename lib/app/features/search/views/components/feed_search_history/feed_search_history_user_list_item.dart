// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/components/search_history/search_list_item_loading.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';

class FeedSearchHistoryUserListItem extends ConsumerWidget {
  const FeedSearchHistoryUserListItem({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));
    return userMetadata.maybeWhen(
      data: (userMetadataEntity) => userMetadataEntity != null
          ? GestureDetector(
              onTap: () => ProfileRoute(pubkey: pubkey).push<void>(context),
              child: _UserListItem(userMetadata: userMetadataEntity.data),
            )
          : const SizedBox.shrink(),
      orElse: ListItemLoading.new,
    );
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({required this.userMetadata});

  final UserMetadata userMetadata;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.0.s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Avatar(size: 65.0.s, imageUrl: userMetadata.picture),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userMetadata.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              Text(
                prefixUsername(username: userMetadata.name, context: context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
