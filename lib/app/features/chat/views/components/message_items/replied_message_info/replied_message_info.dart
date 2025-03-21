// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_message_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/generated/assets.gen.dart';

class RepliedMessageInfo extends HookConsumerWidget {
  const RepliedMessageInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliedMessage = ref.watch(selectedMessageProvider);

    if (repliedMessage == null) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.0.s),
      padding: EdgeInsets.fromLTRB(12.0.s, 5.0.s, 20.0.s, 5.0.s),
      color: context.theme.appColors.onPrimaryAccent,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SideVerticalDivider(),
            if (repliedMessage is PhotoItem)
              Padding(
                padding: EdgeInsets.only(left: 6.0.s, right: 12.0.s),
                child: MediaContent(
                  media: repliedMessage.media,
                  size: Size(30.0.s, 30.0.s),
                ),
              ),
            if (repliedMessage is VideoItem)
              Padding(
                padding: EdgeInsets.only(left: 6.0.s, right: 12.0.s),
                child: MediaContent(
                  media: repliedMessage.media,
                  size: Size(30.0.s, 30.0.s),
                ),
              ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SenderSummary(pubkey: repliedMessage.eventMessage.masterPubkey, isReply: true),
                  Text(
                    repliedMessage.contentDescription,
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.onTertararyBackground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ref.read(selectedMessageProvider.notifier).clear,
              child: Assets.svg.iconSheetClose.icon(
                size: 20.0.s,
                color: context.theme.appColors.tertararyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideVerticalDivider extends StatelessWidget {
  const _SideVerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.0.s,
      margin: EdgeInsets.only(right: 6.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryAccent,
        borderRadius: BorderRadius.circular(2.0.s),
      ),
    );
  }
}
