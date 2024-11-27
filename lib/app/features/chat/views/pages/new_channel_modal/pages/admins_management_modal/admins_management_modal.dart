// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/add_admin_modal/add_admin_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/admins_management_modal/components/admin_card.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class AdminsManagementModal extends HookConsumerWidget {
  const AdminsManagementModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelAdmins = ref.watch(channelAdminsProvider());
    final channelAdminsPubkeys = useMemoized(() => channelAdmins.keys.toList(), [channelAdmins]);

    final buttonSize = 56.0.s;
    final buttonPaddingTop = 8.0.s;
    final separatorHeight = 16.0.s;
    final height = NavigationAppBar.modalHeaderHeight +
        buttonSize +
        buttonPaddingTop +
        separatorHeight +
        (AdminCard.itemHeight + separatorHeight) * channelAdminsPubkeys.length;

    return SizedBox(
      height: height,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              showBackButton: false,
              actions: [
                NavigationCloseButton(
                  onPressed: () => context.pop(),
                ),
              ],
              title: Text(context.i18n.channel_create_admins_title),
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            pinned: true,
          ),
          PinnedHeaderSliver(
            child: ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(top: buttonPaddingTop, bottom: separatorHeight),
                child: Button(
                  mainAxisSize: MainAxisSize.max,
                  minimumSize: Size(buttonSize, buttonSize),
                  leadingIcon: Assets.svg.iconPlusCreatechannel.icon(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
                  label: Text(
                    context.i18n.channel_create_admins_action,
                  ),
                  onPressed: () {
                    showSimpleBottomSheet<void>(
                      context: context,
                      child: const AddAdminModal(),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverList.separated(
            separatorBuilder: (BuildContext _, int __) => SizedBox(height: separatorHeight),
            itemCount: channelAdminsPubkeys.length,
            itemBuilder: (BuildContext context, int index) {
              return ScreenSideOffset.small(
                child: AdminCard(
                  pubkey: channelAdminsPubkeys[index],
                  channelAdminType: channelAdmins[channelAdminsPubkeys[index]]!,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
