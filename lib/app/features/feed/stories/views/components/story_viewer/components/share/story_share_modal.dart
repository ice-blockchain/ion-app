// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/share/story_share_contact_list.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class StoryShareModal extends HookWidget {
  const StoryShareModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (selectedContacts, toggleContactSelection) = useSelectedState<String>();

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.share_via),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSideOffset.defaultSmallMargin,
              vertical: 8.0.s,
            ),
            child: SearchInput(
              onTextChanged: (value) {},
            ),
          ),
          Expanded(
            child: StoryShareContactList(
              selectedContacts: selectedContacts,
              toggleContactSelection: toggleContactSelection,
            ),
          ),
          if (selectedContacts.isNotEmpty)
            Column(
              children: [
                const HorizontalSeparator(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 44.0.s,
                    vertical: 16.0.s,
                  ),
                  child: Button(
                    mainAxisSize: MainAxisSize.max,
                    label: Text(context.i18n.button_send),
                    onPressed: () {
                      // TODO: Implement send logic
                      context.pop();
                    },
                  ),
                ),
              ],
            )
                .animate(target: selectedContacts.isNotEmpty ? 1 : 0)
                .fade(duration: 300.ms)
                .slideY(begin: 0.5, end: 0, duration: 300.ms),
          ScreenBottomOffset(margin: 16.0.s),
        ],
      ),
    );
  }
}
