// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_seperator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageReactionContextMenu extends StatelessWidget {
  const MessageReactionContextMenu({super.key});

  static final height = 237.0.s;
  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.only(top: 6.0.s),
        child: OverlayMenuContainer(
          child: IntrinsicWidth(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.s),
              child: Column(
                children: [
                  OverlayMenuItem(
                    label: context.i18n.button_reply,
                    icon: Assets.svg.iconChatReply.icon(
                      size: iconSize,
                      color: context.theme.appColors.quaternaryText,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    minWidth: 140.0.s,
                    verticalPadding: 12.0.s,
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_forward,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconChatForward
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_copy,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconBlockCopyBlue
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_bookmark,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconBookmarks
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const OverlayMenuItemSeperator(),
                  OverlayMenuItem(
                    label: context.i18n.button_delete,
                    labelColor: context.theme.appColors.attentionRed,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconBlockDelete
                        .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
