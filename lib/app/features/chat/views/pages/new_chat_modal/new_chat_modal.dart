// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/providers/e2ee_group_conversation_management_provider.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/user_picker_sheet.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class NewChatModal extends ConsumerWidget {
  const NewChatModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(usersSearchTextProvider);

    ref.listen(
      e2EEGroupConversationManagementProvider,
      (previous, next) async {
        if (next is AsyncError) {
          await showSimpleBottomSheet<void>(
            context: context,
            child: ErrorModal(error: next.error),
          );
        }
      },
    );

    Future<void> onUserSelected(UserMetadataEntity user) async {
      final ee2eGroupConversationService =
          ref.watch(e2EEGroupConversationManagementProvider.notifier);

      final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

      if (currentPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      await ee2eGroupConversationService
          .createOneOnOneConversation([user.masterPubkey, currentPubkey]);
    }

    return SheetContent(
      topPadding: 0,
      body: UserPickerSheet(
        navigationBar: NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.new_chat_modal_title),
          actions: const [NavigationCloseButton()],
        ),
        initialUserListType: UserListType.follower,
        onUserSelected: onUserSelected,
        header: Row(
          children: [
            _HeaderButton(
              icon: Assets.svg.iconSearchGroups,
              title: context.i18n.new_chat_modal_new_group_button,
              onTap: () {
                AddParticipantsToGroupModalRoute().push<void>(context);
              },
            ),
            SizedBox(width: 20.0.s),
            _HeaderButton(
              icon: Assets.svg.iconSearchChannel,
              title: context.i18n.new_chat_modal_new_channel_button,
              onTap: () {
                NewChannelModalRoute().replace(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button.compact(
        leadingIcon: icon.icon(
          size: 16.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
        type: ButtonType.outlined,
        onPressed: onTap,
        label: Text(
          title,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
      ),
    );
  }
}
