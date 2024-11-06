// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/share/share_actions_buttons.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/share/story_share_contact_list.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class StoryShareModal extends HookWidget {
  const StoryShareModal({super.key});

  @override
  Widget build(BuildContext context) {
    final (selectedContacts, toggleContactSelection) = useSelectedState<String>();

    return SheetContent(
      body: Stack(
        children: [
          Column(
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
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: context.theme.appColors.secondaryBackground,
              child: Column(
                children: [
                  const HorizontalSeparator(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: selectedContacts.isNotEmpty ? 44.0.s : 22.0.s,
                      right: selectedContacts.isNotEmpty ? 44.0.s : 22.0.s,
                      top: 16.0.s,
                      bottom: selectedContacts.isNotEmpty ? 16.0.s : 0.0.s,
                    ),
                    child: selectedContacts.isNotEmpty
                        ? Button(
                            mainAxisSize: MainAxisSize.max,
                            label: Text(context.i18n.button_send),
                            onPressed: () {},
                          )
                        : const ShareActionButtons(),
                  ),
                  ScreenBottomOffset(margin: 20.0.s),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
