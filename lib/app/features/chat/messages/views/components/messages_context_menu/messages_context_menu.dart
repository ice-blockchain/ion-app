// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

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
                    ChatMenuItem(
                      label: 'Share',
                      icon: Assets.svg.iconButtonShare.icon(
                        size: iconSize,
                        color: context.theme.appColors.quaternaryText,
                      ),
                      onPressed: closeMenu,
                    ),
                    Container(
                      height: 0.5.s,
                      width: double.infinity,
                      color: context.theme.appColors.onTerararyFill,
                    ),
                    ChatMenuItem(
                      label: 'Mute',
                      icon: Assets.svg.iconChannelMute
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    Container(
                      height: 0.5.s,
                      width: double.infinity,
                      color: context.theme.appColors.onTerararyFill,
                    ),
                    ChatMenuItem(
                      label: 'Block',
                      icon: Assets.svg.iconPhofileBlockuser
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    Container(
                      height: 0.5.s,
                      width: double.infinity,
                      color: context.theme.appColors.onTerararyFill,
                    ),
                    ChatMenuItem(
                      label: 'Report',
                      icon: Assets.svg.iconBlockClose3
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    Container(
                      height: 0.5.s,
                      width: double.infinity,
                      color: context.theme.appColors.onTerararyFill,
                    ),
                    ChatMenuItem(
                      label: 'Delete',
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

class ChatMenuItem extends StatelessWidget {
  const ChatMenuItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.labelColor,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 8.0.s),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 99.0.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textStyles.subtitle3.copyWith(
                    color: labelColor ?? colors.primaryText,
                  ),
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
