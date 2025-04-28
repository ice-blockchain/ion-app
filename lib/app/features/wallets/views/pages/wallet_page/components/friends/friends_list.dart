// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/friends/friends_list_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/friends/friends_list_item.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/friends/friends_list_loader.dart';
import 'package:ion/app/router/app_routes.c.dart';

class FriendsList extends ConsumerWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsDataState = ref.watch(currentUserFollowListProvider);

    final footer = SizedBox(
      height: ScreenSideOffset.defaultSmallMargin,
    );

    return friendsDataState.maybeWhen(
      skipLoadingOnRefresh: false,
      data: (friends) {
        final friendsPubkeys = friends?.pubkeys ?? [];

        return Column(
          children: [
            const FriendsListHeader(),
            SizedBox(
              height: FriendsListItem.height,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSideOffset.defaultSmallMargin,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: friendsPubkeys.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 12.0.s);
                },
                itemBuilder: (BuildContext context, int index) {
                  final friendPubkey = friendsPubkeys[index];

                  return FriendsListItem(
                    pubkey: friendPubkey,
                    onTap: () async {
                      final needToEnable2FA =
                          await ContactRoute(pubkey: friendPubkey).push<bool>(context);
                      if (needToEnable2FA != null && needToEnable2FA == true) {
                        await Future<void>.delayed(const Duration(seconds: 1));
                        if (context.mounted) {
                          await SecureAccountModalRoute().push<void>(context);
                        }
                      }
                    },
                  );
                },
              ),
            ),
            footer,
          ],
        );
      },
      orElse: () => FriendsListLoader(footer: footer),
    );
  }
}
