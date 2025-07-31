// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_avatar/ion_connect_avatar.dart';
import 'package:ion/app/features/search/views/components/search_history/search_list_item_loading.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/utils/username.dart';

class FeedSearchHistoryUserListItem extends ConsumerWidget {
  const FeedSearchHistoryUserListItem({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));
    return userMetadata.maybeWhen(
      data: (userMetadata) => userMetadata != null
          ? GestureDetector(
              onTap: () => ProfileRoute(pubkey: pubkey).push<void>(context),
              child: _UserListItem(userMetadata: userMetadata),
            )
          : const SizedBox.shrink(),
      orElse: ListItemLoading.new,
    );
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({required this.userMetadata});

  final UserMetadataEntity userMetadata;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.0.s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IonConnectAvatar(size: 65.0.s, pubkey: userMetadata.masterPubkey),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userMetadata.data.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              Text(
                prefixUsername(username: userMetadata.data.name, context: context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.terararyText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
