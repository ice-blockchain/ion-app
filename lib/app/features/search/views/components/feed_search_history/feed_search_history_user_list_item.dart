// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';

class FeedSearchHistoryUserListItem extends ConsumerWidget {
  const FeedSearchHistoryUserListItem({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(userId));
    return userMetadata.maybeWhen(
      data: (data) => data != null ? _UserListItem(userMetadata: data) : const SizedBox.shrink(),
      orElse: _UserListItemLoading.new,
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
          Avatar(size: 65.0.s, imageUrl: userMetadata.picture, hexagon: userMetadata.nft),
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

class _UserListItemLoading extends StatelessWidget {
  const _UserListItemLoading();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        children: [
          Container(
            width: 65.0.s,
            height: 65.0.s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0.s),
            ),
          ),
          SizedBox(height: 6.0.s),
          Container(
            width: 65.0.s,
            height: 34.0.s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0.s),
            ),
          ),
        ],
      ),
    );
  }
}
