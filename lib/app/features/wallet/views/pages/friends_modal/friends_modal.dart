// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/user_picker_sheet.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class FriendsModal extends StatelessWidget {
  const FriendsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      topPadding: 0,
      body: UserPickerSheet(
        navigationBar: NavigationAppBar.modal(
          title: Text(context.i18n.friends_modal_title),
          actions: const [NavigationCloseButton()],
        ),
        onUserSelected: (user) => context.pop(user.masterPubkey),
      ),
    );
  }
}
