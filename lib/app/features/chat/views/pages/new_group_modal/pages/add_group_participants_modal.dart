// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/chat_participant_data.c.dart';
import 'package:ion/app/features/chat/providers/create_group_form_controller_provider.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/user_picker_sheet.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class AddGroupParticipantsModal extends HookConsumerWidget {
  const AddGroupParticipantsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createGroupForm = ref.watch(createGroupFormControllerProvider);
    final createGroupFormNotifier = ref.watch(createGroupFormControllerProvider.notifier);

    return SheetContent(
      topPadding: 0,
      body: UserPickerSheet(
        selectable: true,
        initialUserListType: UserListType.follower,
        key: const Key('add-group-participants-modal'),
        selectedPubkeys: createGroupForm.members.map((e) => e.masterPubkey).toList(),
        onUserSelected: (user) {
          createGroupFormNotifier.toggleMember(
            ChatParticipantData(
              pubkey: user.pubkey,
              masterPubkey: user.masterPubkey,
            ),
          );
        },
        navigationBar: NavigationAppBar.modal(
          title: Text(context.i18n.group_create_title),
          showBackButton: false,
          actions: const [
            NavigationCloseButton(),
          ],
        ),
        bottomContent: Column(
          children: [
            const HorizontalSeparator(),
            ScreenBottomOffset(
              margin: 32.0.s,
              child: Padding(
                padding: EdgeInsets.only(top: 16.0.s),
                child: ScreenSideOffset.large(
                  child: Button(
                    onPressed: () {
                      CreateGroupModalRoute().push<void>(context);
                    },
                    label: Text(context.i18n.button_next),
                    mainAxisSize: MainAxisSize.max,
                    trailingIcon: Assets.svg.iconButtonNext.icon(
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
