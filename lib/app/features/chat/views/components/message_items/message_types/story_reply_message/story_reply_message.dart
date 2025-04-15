// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/story_reply_message_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryReplyMessage extends HookConsumerWidget {
  const StoryReplyMessage({required this.eventMessage, super.key});

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = useMemoized(() => PrivateDirectMessageEntity.fromEventMessage(eventMessage));
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final story = entity.data.quotedEvent != null
        ? ref
            .watch(
              storyReplyMessageProvider(entity.data.quotedEvent!.eventReference.eventId),
            )
            .valueOrNull
        : null;
    final storyUrl = story?.data.media.values.firstOrNull?.url ?? '';

    return Align(
      alignment: isMe ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _SenderReceiverLabel(isMe: isMe),
              if (storyUrl.isNotEmpty)
                _StoryImage(storyUrl: storyUrl)
              else
                _UnavailableStoryContainer(isMe: isMe, eventMessage: eventMessage),
              if (eventMessage.content.isNotEmpty)
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 4.0.s),
                  child: TextMessage(eventMessage: eventMessage),
                ),
            ],
          ),
          if (storyUrl.isNotEmpty)
            PositionedDirectional(
              bottom: 6.0.s,
              start: 6.0.s,
              child: MessageReactions(eventMessage: eventMessage, isMe: isMe),
            ),
        ],
      ),
    );
  }
}

class _SenderReceiverLabel extends StatelessWidget {
  const _SenderReceiverLabel({required this.isMe});

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Text(
      isMe ? context.i18n.story_reply_sender : context.i18n.story_reply_receiver,
      style: context.theme.appTextThemes.caption3.copyWith(
        color: context.theme.appColors.quaternaryText,
      ),
    );
  }
}

class _StoryImage extends StatelessWidget {
  const _StoryImage({required this.storyUrl});

  final String storyUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: storyUrl,
      imageBuilder: (_, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(12.0.s),
        child: Image(image: imageProvider, height: 220.0.s),
      ),
      errorWidget: (context, url, error) => const SizedBox.shrink(),
    );
  }
}

class _UnavailableStoryContainer extends StatelessWidget {
  const _UnavailableStoryContainer({required this.isMe, required this.eventMessage});

  final bool isMe;
  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6.0.s,
        horizontal: 6.0.s,
      ),
      constraints: BoxConstraints(
        maxWidth: MessageItemWrapper.maxWidth,
      ),
      decoration: BoxDecoration(
        color:
            isMe ? context.theme.appColors.primaryAccent : context.theme.appColors.onPrimaryAccent,
        borderRadius: BorderRadiusDirectional.all(
          Radius.circular(12.0.s),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.svg.iconFeedStories.icon(
                color: isMe
                    ? context.theme.appColors.onPrimaryAccent
                    : context.theme.appColors.quaternaryText,
              ),
              SizedBox(width: 4.0.s),
              Text(
                isMe ? 'Content unavailable' : 'Unavailable story',
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: isMe
                      ? context.theme.appColors.onPrimaryAccent
                      : context.theme.appColors.quaternaryText,
                ),
              ),
            ],
          ),
          MessageReactions(eventMessage: eventMessage, isMe: isMe),
        ],
      ),
    );
  }
}
