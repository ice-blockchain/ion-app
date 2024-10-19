// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/types/follow_type.dart';
import 'package:ion/app/features/user/providers/user_followers_provider.dart';
import 'package:ion/app/features/user/providers/user_following_provider.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class FollowListView extends ConsumerWidget {
  const FollowListView({
    required this.followType,
    required this.pubkey,
    super.key,
  });

  final FollowType followType;
  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdsResult = (followType == FollowType.followers
        ? ref.watch(userFollowersProvider(pubkey))
        : ref.watch(userFollowingProvider(pubkey)));

    final counter = userIdsResult.valueOrNull?.length ?? 0;

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              actions: [
                NavigationCloseButton(
                  onPressed: () => context.pop(),
                ),
              ],
              title: Text(followType.getTitleWithCounter(context, counter)),
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            pinned: true,
          ),
          PinnedHeaderSliver(
            child: ColoredBox(
              color: context.theme.appColors.onPrimaryAccent,
              child: Column(
                children: [
                  SizedBox(height: 16.0.s),
                  ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) {},
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                ],
              ),
            ),
          ),
          userIdsResult.maybeWhen(
            data: (userIds) {
              final userIdsList = userIds.toList();

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final pubkey = userIdsList[index];
                    return ScreenSideOffset.small(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.0.s),
                        child: FollowListItem(
                          pubkey: pubkey,
                        ),
                      ),
                    );
                  },
                  childCount: userIdsList.length,
                ),
              );
            },
            orElse: () => ListItemsLoadingState(
              itemsCount: 11,
              itemHeight: 35.0.s,
            ),
          ),
        ],
      ),
    );
  }
}
