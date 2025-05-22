// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/components/blocked_user_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/components/blocked_users_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/components/blocked_users_search_bar.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class BlockedUsersModal extends HookConsumerWidget {
  const BlockedUsersModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(true);
    // We fetch the data once and keep it in state so that it doesn't cause users to disappear after unblocking
    final pubkeys = useState<List<String>>([]);
    useOnInit(() async {
      final blockList = await ref.read(currentUserBlockListProvider.future);
      pubkeys.value = blockList?.data.pubkeys ?? [];
      isLoading.value = false;
    });

    return SheetContent(
      topPadding: 0,
      body: CustomScrollView(
        slivers: [
          const BlockedUsersAppBar(),
          const BlockedUsersSearchBar(),
          if (!isLoading.value)
            SliverList.separated(
              separatorBuilder: (_, __) => SizedBox(height: 16.0.s),
              itemCount: pubkeys.value.length,
              itemBuilder: (context, index) => ScreenSideOffset.small(
                child: BlockedUserListItem(pubkey: pubkeys.value[index]),
              ),
            )
          else
            ListItemsLoadingState(
              itemHeight: BlockedUserListItem.itemHeight,
              padding: EdgeInsets.zero,
              listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
            ),
          SliverPadding(padding: EdgeInsetsDirectional.only(bottom: 32.0.s)),
        ],
      ),
    );
  }
}
