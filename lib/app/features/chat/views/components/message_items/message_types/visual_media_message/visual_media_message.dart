// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_medias_provider.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_custom_grid.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_metadata.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/router/app_routes.c.dart';

class VisualMediaMessage extends HookConsumerWidget {
  const VisualMediaMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  static double get padding => 6.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final messageMedias =
        ref.watch(chatMediasProvider(eventMessageId: eventMessage.id)).valueOrNull ?? [];

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: MediaItem(
        medias: messageMedias,
        eventMessage: eventMessage,
        contentDescription: context.i18n.common_media,
      ),
      contentPadding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () {
          //TODO: show full screen media
          PhotoGalleryRoute(
            eventMessageId: eventMessage.id,
            initialIndex: 0,
          ).push<void>(context);
        },
        child: SizedBox(
          width: messageMedias.length > 1 ? double.infinity : 146.0.s,
          child: Column(
            children: [
              VisualMediaCustomGrid(
                messageMedias: messageMedias,
                eventMessage: eventMessage,
              ),
              VisualMediaMetadata(
                eventMessage: eventMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
