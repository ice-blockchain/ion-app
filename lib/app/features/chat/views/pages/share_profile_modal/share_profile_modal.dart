// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/user_picker_sheet.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ShareProfileModal extends HookConsumerWidget {
  const ShareProfileModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onUserSelected = useCallback(
      (UserMetadataEntity user) {
        context.pop();
      },
      [],
    );

    return SheetContent(
      topPadding: 0,
      body: UserPickerSheet(
        navigationBar: NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.chat_profile_share_modal_title),
          actions: [NavigationCloseButton(onPressed: () => context.pop())],
        ),
        onUserSelected: onUserSelected,
      ),
    );
  }
}
