// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/providers/muted_conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/pages/recent_chat_overlay/recent_chat_overlay.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatTile extends HookConsumerWidget {
  const RecentChatTile({
    required this.conversation,
    required this.name,
    required this.defaultAvatar,
    required this.lastMessageAt,
    required this.lastMessageContent,
    required this.unreadMessagesCount,
    required this.messageType,
    required this.onTap,
    this.avatarUrl,
    this.avatarWidget,
    super.key,
  });

  final ConversationListItem conversation;
  final String name;
  final String? avatarUrl;
  final Widget? defaultAvatar;
  final DateTime lastMessageAt;
  final String lastMessageContent;
  final int unreadMessagesCount;
  final VoidCallback? onTap;
  final Widget? avatarWidget;
  final MessageType messageType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(conversationsEditModeProvider);
    final selectedConversations = ref.watch(selectedConversationsProvider);

    final isMuted = ref
            .watch(mutedConversationIdsProvider)
            .valueOrNull
            ?.contains(conversation.conversationId) ??
        false;

    final messageItemKey = useMemoized(GlobalKey.new);

    final showRecentChatOverlay = useCallback(
      () {
        showDialog<void>(
          context: context,
          barrierColor: Colors.transparent,
          useSafeArea: false,
          builder: (context) => RecentChatOverlay(
            conversation: conversation,
            renderObject: messageItemKey.currentContext!.findRenderObject()!,
          ),
        );
      },
      [messageItemKey],
    );

    return GestureDetector(
      onTap: () {
        if (isEditMode) {
          ref.read(selectedConversationsProvider.notifier).toggle(conversation);
        } else {
          onTap?.call();
        }
      },
      onLongPress: showRecentChatOverlay,
      behavior: HitTestBehavior.opaque,
      child: RepaintBoundary(
        key: messageItemKey,
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.appColors.secondaryBackground,
          ),
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isEditMode ? 40.0.s : 0,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: 10.0.s),
                  child: selectedConversations.contains(conversation)
                      ? Assets.svg.iconBlockCheckboxOn.icon(size: 24.0.s)
                      : Assets.svg.iconBlockCheckboxOff.icon(size: 24.0.s),
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    Avatar(
                      imageUrl: avatarUrl,
                      imageWidget: avatarWidget,
                      defaultAvatar: defaultAvatar,
                      size: 40.0.s,
                    ),
                    SizedBox(width: 12.0.s),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: <Widget>[
                                  Text(
                                    name,
                                    style: context.theme.appTextThemes.subtitle3.copyWith(
                                      color: context.theme.appColors.primaryText,
                                    ),
                                  ),
                                  if (isMuted)
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(start: 4.0.s),
                                      child: Assets.svg.iconChannelfillMute.icon(size: 16.0.s),
                                    ),
                                ],
                              ),
                              ChatTimestamp(lastMessageAt),
                            ],
                          ),
                          SizedBox(height: 2.0.s),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ChatPreview(
                                  content: lastMessageContent,
                                  messageType: messageType,
                                ),
                              ),
                              UnreadCountBadge(unreadCount: unreadMessagesCount, isMuted: isMuted),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SenderSummary extends ConsumerWidget {
  const SenderSummary({
    required this.pubkey,
    this.textColor,
    this.isReply = false,
    super.key,
  });

  final bool isReply;
  final String pubkey;

  final Color? textColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.data;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (isReply)
          Padding(
            padding: EdgeInsetsDirectional.only(end: 4.0.s),
            child: Assets.svg.iconChatReply.icon(
              size: 16.0.s,
              color: context.theme.appColors.quaternaryText,
            ),
          ),
        Text(
          user.name,
          style: context.theme.appTextThemes.subtitle3.copyWith(
            color: textColor ?? context.theme.appColors.primaryText,
          ),
        ),
      ],
    );
  }
}

class ChatTimestamp extends StatelessWidget {
  const ChatTimestamp(this.time, {super.key});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatMessageTimestamp(time),
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}

class ChatPreview extends HookConsumerWidget {
  const ChatPreview({
    required this.content,
    required this.messageType,
    this.textColor,
    this.maxLines = 2,
    super.key,
  });

  final String content;
  final Color? textColor;
  final int maxLines;
  final MessageType messageType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        RecentChatMessageIcon(messageType: messageType, color: textColor),
        Flexible(
          child: Text(
            switch (messageType) {
              MessageType.text => content,
              MessageType.emoji => content,
              MessageType.audio => context.i18n.common_voice_message,
              MessageType.visualMedia => context.i18n.common_media,
              MessageType.document => content,
              MessageType.profile => ref
                      .watch(userMetadataProvider(EventReference.fromEncoded(content).pubkey))
                      .valueOrNull
                      ?.data
                      .displayName ??
                  '',
            },
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: context.theme.appTextThemes.body2.copyWith(
              color: textColor ?? context.theme.appColors.onTertararyBackground,
            ),
          ),
        ),
      ],
    );
  }
}

class RecentChatMessageIcon extends StatelessWidget {
  const RecentChatMessageIcon({required this.messageType, this.color, super.key});

  final MessageType messageType;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final messageIconPath = _getMessageIcon();

    if (messageIconPath != null) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: 2.0.s),
        child: messageIconPath.icon(
          size: 16.0.s,
          color: color ?? context.theme.appColors.onTertararyBackground,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String? _getMessageIcon() => switch (messageType) {
        MessageType.text => null,
        MessageType.emoji => null,
        // MessageType.video => Assets.svg.iconFeedVideos,
        MessageType.audio => Assets.svg.iconChatVoicemessage,
        MessageType.profile => Assets.svg.iconProfileUsertab,
        MessageType.document => Assets.svg.iconChatFile,
        MessageType.visualMedia => Assets.svg.iconProfileCamera,
      };
}

class UnreadCountBadge extends StatelessWidget {
  const UnreadCountBadge({required this.unreadCount, required this.isMuted, super.key});

  final int unreadCount;
  final bool isMuted;
  @override
  Widget build(BuildContext context) {
    if (unreadCount == 0) {
      return SizedBox(width: 24.0.s);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: isMuted ? context.theme.appColors.sheetLine : context.theme.appColors.primaryAccent,
      ),
      alignment: Alignment.center,
      constraints: BoxConstraints(
        minWidth: 16.0.s,
        minHeight: 16.0.s,
        maxHeight: 16.0.s,
      ),
      padding: EdgeInsetsDirectional.fromSTEB(5.0.s, 0, 5.0.s, 1.0.s),
      margin: EdgeInsetsDirectional.only(start: 16.0.s),
      child: Text(
        unreadCount.toString(),
        textAlign: TextAlign.center,
        style: context.theme.appTextThemes.caption3.copyWith(
          height: 1,
          color: context.theme.appColors.onPrimaryAccent,
          fontFeatures: [
            const FontFeature.enable('liga'),
            const FontFeature.disable('clig'),
          ],
        ),
      ),
    );
  }
}
