// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class BlockedUsersAppBar extends ConsumerWidget {
  const BlockedUsersAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(currentUserBlockListProvider).valueOrNull?.data.pubkeys.length ?? 0;

    return SliverAppBar(
      primary: false,
      flexibleSpace: NavigationAppBar.modal(
        actions: const [NavigationCloseButton()],
        title: Text(context.i18n.settings_blocked_users_title_with_counter(counter)),
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: NavigationAppBar.modalHeaderHeight,
      pinned: true,
    );
  }
}
