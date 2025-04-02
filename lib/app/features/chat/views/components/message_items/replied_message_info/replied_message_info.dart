// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_message_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_custom_grid.dart';
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
      margin: EdgeInsetsDirectional.only(bottom: 12.0.s),
      padding: EdgeInsetsDirectional.fromSTEB(12.0.s, 5.0.s, 20.0.s, 5.0.s),
      color: context.theme.appColors.onPrimaryAccent,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SideVerticalDivider(),
            if (repliedMessage is MediaItem)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 6.0.s, end: 12.0.s),
                child: SizedBox(
                  width: 30.0.s,
                  child: VisualMediaCustomGrid(
                    customSpacing: 2.0.s,
                    customHeight: repliedMessage.medias.length > 1 ? 18.0.s : 30.0.s,
                    messageMedias: repliedMessage.medias,
                    eventMessage: repliedMessage.eventMessage,
                  ),
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
      margin: EdgeInsetsDirectional.only(end: 6.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryAccent,
        borderRadius: BorderRadius.circular(2.0.s),
      ),
    );
  }
}
