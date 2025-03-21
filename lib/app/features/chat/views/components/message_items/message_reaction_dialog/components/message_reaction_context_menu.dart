// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_separator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_delete_event_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_chat_message_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
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
    final hideChatBookmark =
        ref.watch(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideChatBookmark);

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.only(top: 6.0.s),
        child: OverlayMenuContainer(
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
                    final entity = PrivateDirectMessageEntity.fromEventMessage(messageEvent);

                    final messageStatuses = await ref
                        .read(conversationMessageDataDaoProvider)
                        .messageStatuses(messageEvent.id);

                    final failedParticipantsMasterPubkeysMap = messageStatuses
                      ..removeWhere((key, value) => value != MessageDeliveryStatus.failed);

                    final failedParticipantsMasterPubkeys =
                        failedParticipantsMasterPubkeysMap.keys.toList();

                    final mediaFiles = entity.data.media.values
                        .map(
                          (media) => MediaFile(
                            path: media.url,
                            mimeType: media.mimeType,
                            height: int.parse(media.dimension.split('x').first),
                            width: int.parse(media.dimension.split('x').last),
                          ),
                        )
                        .toList();

                    unawaited(
                      ref.watch(sendChatMessageNotifierProvider.notifier).sendMessage(
                            conversationId: entity.data.uuid,
                            participantsMasterPubkeys: entity.allPubkeys,
                            mediaFiles: mediaFiles,
                            content: messageEvent.content,
                            failedEventMessageId: messageEvent.id,
                            failedParticipantsMasterPubkeys: failedParticipantsMasterPubkeys,
                          ),
                    );

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
                if (!hideChatBookmark) ...[
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
    );
  }
}
