// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

part 'components/chat_menu_item.dart';
part 'components/chat_menu_item_seperator.dart';

class MessagingContextMenu extends StatelessWidget {
  const MessagingContextMenu({super.key});

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: IntrinsicWidth(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0.s),
                child: Column(
                  children: [
                    _ChatMenuItem(
                      label: context.i18n.button_share,
                      icon: Assets.svg.iconButtonShare.icon(
                        size: iconSize,
                        color: context.theme.appColors.quaternaryText,
                      ),
                      onPressed: closeMenu,
                    ),
                    _ChatMenuItemSeperator(),
                    _ChatMenuItem(
                      label: context.i18n.button_mute,
                      icon: Assets.svg.iconChannelMute
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    _ChatMenuItemSeperator(),
                    _ChatMenuItem(
                      label: context.i18n.button_block,
                      icon: Assets.svg.iconPhofileBlockuser
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    _ChatMenuItemSeperator(),
                    _ChatMenuItem(
                      label: context.i18n.button_report,
                      icon: Assets.svg.iconBlockClose3
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    _ChatMenuItemSeperator(),
                    _ChatMenuItem(
                      label: context.i18n.button_delete,
                      labelColor: context.theme.appColors.attentionRed,
                      icon: Assets.svg.iconBlockDelete
                          .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                      onPressed: closeMenu,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}