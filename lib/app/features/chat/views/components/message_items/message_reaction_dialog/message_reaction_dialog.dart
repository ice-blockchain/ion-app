// SPDX-License-Identifier: ice License 1.0

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reaction_dialog/components/message_reaction_context_menu.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reaction_dialog/components/message_reaction_emoji_bar.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class MessageReactionDialog extends HookConsumerWidget {
  const MessageReactionDialog({
    required this.isMe,
    required this.renderObject,
    required this.messageItem,
    required this.messageStatus,
    super.key,
  });

  final bool isMe;
  final ChatMessageInfoItem messageItem;
  final MessageDeliveryStatus messageStatus;

  /// The key of the message item to capture the image from widget tree
  final RenderObject renderObject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextMenuHeight = useMemoized(() {
      final hideChatBookmark =
          ref.read(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideChatBookmark);

      final heightOfFailedMessageOverlayMenu = 103.0.s;
      final heightOfSuccessMessageOverlayMenu = 185.0.s;
      final heightOfSuccessMessageOverlayMenuWithBookmark = 203.0.s;

      if (messageStatus == MessageDeliveryStatus.failed) {
        return heightOfFailedMessageOverlayMenu;
      }

      if (hideChatBookmark) {
        return heightOfSuccessMessageOverlayMenu;
      }

      return heightOfSuccessMessageOverlayMenuWithBookmark;
    });

    final capturedImage = useFuture(
      useMemoized(
        () => ref.read(mediaServiceProvider).captureWidgetAsImage(renderObject),
        [renderObject],
      ),
    );

    if (!capturedImage.hasData) {
      return const SizedBox.shrink();
    }

    final (:imageBytes, :position, :size) = capturedImage.data!;

    /// The available height for the message content in the dialog
    final availableHeight = MediaQuery.sizeOf(context).height -
        MessageReactionEmojiBar.height -
        contextMenuHeight -
        MediaQuery.paddingOf(context).bottom -
        MediaQuery.paddingOf(context).top;

    /// Determine the height of the message content in the dialog to fit the available height
    final contentHeight = min(size.height, availableHeight);

    /// Whether the message content is larger than the available height
    final isHugeComponent = size.height > availableHeight;

    /// The y-coordinate of the bottom of the message content
    final bottomdY = position.dy + size.height;

    /// The overflow size of the message content in the dialog
    final overflowBottomSize = MediaQuery.sizeOf(context).height -
        // bottomdY -
        (position.dy > 0 ? (isHugeComponent ? 0 : bottomdY) : bottomdY) -
        contextMenuHeight -
        MediaQuery.paddingOf(context).bottom;

    /// The y-coordinate of the top of the message content in the dialog
    final topY = isHugeComponent
        ? null
        : overflowBottomSize < 0
            ? null
            : position.dy - MessageReactionEmojiBar.height - 2;

    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.opaque,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: context.theme.appColors.primaryText.withValues(alpha: 0.5),
            ),
          ),
        ),
        PositionedDirectional(
          start: isMe ? null : ScreenSideOffset.defaultSmallMargin,
          end: isMe ? ScreenSideOffset.defaultSmallMargin : null,
          top: topY,
          bottom: overflowBottomSize < 0
              ? MediaQuery.paddingOf(context).bottom
              : MediaQuery.paddingOf(context).bottom,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MessageReactionEmojiBar(isMe: isMe),
                Image.memory(
                  imageBytes,
                  height: contentHeight,
                  width: size.width,
                  fit: BoxFit.fitHeight,
                ),
                IntrinsicWidth(
                  child: MessageReactionContextMenu(
                    messageItem: messageItem,
                    height: contextMenuHeight,
                    messageStatus: messageStatus,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
