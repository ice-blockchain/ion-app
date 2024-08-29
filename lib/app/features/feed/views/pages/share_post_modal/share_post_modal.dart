import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/shadow/bottom_menu_shadow.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/share_post_modal/components/share_send_button.dart';
import 'package:ice/app/features/feed/views/pages/share_post_modal/components/share_options.dart';
import 'package:ice/app/features/feed/views/pages/share_post_modal/components/share_user_list.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SharePostModal extends HookWidget {
  const SharePostModal({super.key});

  @override
  Widget build(BuildContext context) {
    final users = useRef(List.generate(20, (index) => index));

    final visibleUsers = useState([...users.value]);

    final selectedUserIds = useState(Set<int>());

    void onUserPressed(int userId) {
      if (selectedUserIds.value.contains(userId)) {
        selectedUserIds.value = {...selectedUserIds.value}..remove(userId);
      } else {
        selectedUserIds.value = {...selectedUserIds.value}..add(userId);
      }
    }

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
              selectedUserIds: selectedUserIds.value,
              onUserPressed: onUserPressed,
            ),
          ),
          BottomMenuShadow(
            child: SizedBox(
              height: 110.0.s,
              child: selectedUserIds.value.isEmpty ? const ShareOptions() : ShareSendButton(),
            ),
          ),
        ],
      ),
    );
  }
}
