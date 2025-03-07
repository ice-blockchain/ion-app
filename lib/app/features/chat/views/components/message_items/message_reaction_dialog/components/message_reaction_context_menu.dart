// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_separator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_delete_event_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageReactionContextMenu extends ConsumerWidget {
  const MessageReactionContextMenu({
    required this.height,
    required this.messageEvent,
    required this.messageStatus,
    super.key,
  });

  final double height;
  final EventMessage messageEvent;
  final MessageDeliveryStatus messageStatus;

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.only(top: 6.0.s),
        child: OverlayMenuContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0.s),
            child: Column(
              children: [
                if (messageStatus == MessageDeliveryStatus.failed)
                  OverlayMenuItem(
                    label: context.i18n.button_retry,
                    icon: Assets.svg.iconMessageRetry.icon(
                      size: iconSize,
                      color: context.theme.appColors.quaternaryText,
                    ),
                    onPressed: () async {
                      final sendE2eeMessageProvider =
                          await ref.read(sendE2eeMessageServiceProvider.future);

                      unawaited(sendE2eeMessageProvider.resendFailedMessage(messageEvent));

                      if (context.mounted) {
                        context.pop();
                      }
                    },
                    minWidth: 140.0.s,
                    verticalPadding: 12.0.s,
                  )
                else ...[
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
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_forward,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconChatForward
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_copy,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconBlockCopyBlue
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_bookmark,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconBookmarks
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                const OverlayMenuItemSeparator(),
                OverlayMenuItem(
                  label: context.i18n.button_delete,
                  labelColor: context.theme.appColors.attentionRed,
                  verticalPadding: 12.0.s,
                  icon: Assets.svg.iconBlockDelete
                      .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                  onPressed: () async {
                    final forEveryone = await DeleteMessageRoute().push<bool>(context);

                    if (forEveryone != null && context.mounted) {
                      final messageEventsList = [messageEvent];
                      ref.read(
                        e2eeDeleteMessageProvider(
                          messageEvents: messageEventsList,
                          forEveryone: forEveryone,
                        ),
                      );
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
