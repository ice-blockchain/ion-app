// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/components/share_send_button.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/user_picker_sheet.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ShareModalBase extends HookWidget {
  const ShareModalBase({
    required this.title,
    required this.emptyStateWidget,
    this.showNextIcon = true,
    super.key,
  });

  final String title;
  final bool showNextIcon;
  final Widget emptyStateWidget;

  @override
  Widget build(BuildContext context) {
    final (selectedPubkeys, togglePubkeySelection) = useSelectedState<String>();

    return SheetContent(
      body: Column(
        children: [
          Flexible(
            child: UserPickerSheet(
              selectable: true,
              selectedPubkeys: selectedPubkeys,
              navigationBar: NavigationAppBar.modal(
                title: Text(title),
                actions: const [NavigationCloseButton()],
                showBackButton: false,
              ),
              onUserSelected: (user) => togglePubkeySelection(user.masterPubkey),
            ),
          ),
          const HorizontalSeparator(),
          SizedBox(
            height: 110.0.s,
            child: selectedPubkeys.isEmpty
                ? emptyStateWidget
                : ShareSendButton(showNextIcon: showNextIcon),
          ),
        ],
      ),
    );
  }
}
