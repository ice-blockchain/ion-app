import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';
import 'package:ice/app/features/feed/feed_search/providers/mocked_search_users.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/utils/username.dart';

class FeedSearchHistoryUserListItem extends HookWidget {
  const FeedSearchHistoryUserListItem({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final user = useState<FeedSearchUser?>(
      // Simulate that user might be either loaded or not
      Random().nextBool() ? mockedFeedSearchUsers.firstWhere((user) => user.id == userId) : null,
    );

    // Simulate loading user data
    useOnInit(() {
      if (user.value == null) {
        Future<void>.delayed(Duration(milliseconds: Random().nextInt(500) + 500)).then(
          (value) {
            user.value = mockedFeedSearchUsers.firstWhere((user) => user.id == userId);
          },
        );
      }
    });

    return user.value != null ? _UserListItem(user: user.value!) : _UserListItemLoading();
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({required this.user});

  final FeedSearchUser user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.0.s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Avatar(size: 65.0.s, imageUrl: user.imageUrl, hexagon: user.nft),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              Text(
                prefixUsername(username: user.nickname, context: context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
            ],
          )
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
