// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/components/share_options.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/components/share_send_button.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/components/share_user_list.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class SharePostModal extends HookWidget {
  const SharePostModal({required this.postId, super.key});

  final String postId;

  @override
  Widget build(BuildContext context) {
    final users = useRef(List.generate(20, (index) => index));

    final (selectedUserIds, toggleUserSelection) = useSelectedState<int>();

    final visibleUsers = useState([...users.value]);

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.feed_share_via),
            actions: [NavigationCloseButton(onPressed: context.pop)],
          ),
          SizedBox(height: 9.0.s),
          ScreenSideOffset.small(
            child: SearchInput(
              onTextChanged: (String text) {
                visibleUsers.value = text.isNotEmpty
                    ? users.value.takeWhile((id) => id < 4).toList()
                    : [...users.value];
              },
            ),
          ),
          SizedBox(height: 8.0.s),
          Flexible(
            child: ShareUserList(
              users: visibleUsers.value,
              selectedUserIds: selectedUserIds.toSet(),
              onUserPressed: toggleUserSelection,
            ),
          ),
          const HorizontalSeparator(),
          SizedBox(
            height: 110.0.s,
            child: selectedUserIds.isEmpty ? const ShareOptions() : const ShareSendButton(),
          ),
        ],
      ),
    );
  }
}
