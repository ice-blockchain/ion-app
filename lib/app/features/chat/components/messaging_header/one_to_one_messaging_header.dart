// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/messages_context_menu/one_to_one_messages_context_menu.dart';
import 'package:ion/app/features/user/providers/badges_notifier.c.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/generated/assets.gen.dart';

class OneToOneMessagingHeader extends ConsumerWidget {
  const OneToOneMessagingHeader({
    required this.name,
    required this.subtitle,
    required this.conversationId,
    required this.receiverMasterPubkey,
    this.imageUrl,
    this.imageWidget,
    this.onTap,
    this.onToggleMute,
    super.key,
  });

  final String name;

  final Widget subtitle;
  final String? imageUrl;
  final Widget? imageWidget;
  final String conversationId;
  final GestureTapCallback? onTap;
  final VoidCallback? onToggleMute;
  final String receiverMasterPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBlocked =
        ref.watch(isBlockedNotifierProvider(receiverMasterPubkey)).valueOrNull ?? true;
    final isBlockedBy =
        ref.watch(isBlockedByNotifierProvider(receiverMasterPubkey)).valueOrNull ?? true;
    final isVerified = ref.watch(isUserVerifiedProvider(receiverMasterPubkey)).valueOrNull ?? false;
    final isNicknameProven =
        ref.watch(isNicknameProvenProvider(receiverMasterPubkey)).valueOrNull ?? true;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0.s, 8.0.s, 16.0.s, 12.0.s),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Assets.svg.iconChatBack.icon(
              size: 24.0.s,
              flipForRtl: true,
            ),
          ),
          SizedBox(width: 12.0.s),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  if (isBlockedBy)
                    Avatar(size: 36.0.s)
                  else
                    Avatar(
                      size: 36.0.s,
                      imageWidget: imageWidget,
                      imageUrl: imageWidget != null ? null : imageUrl,
                    ),
                  SizedBox(width: 10.0.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                style: context.theme.appTextThemes.subtitle3,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (isVerified) ...[
                              SizedBox(width: 3.0.s),
                              Assets.svg.iconBadgeVerify.icon(size: 16.0.s),
                            ],
                          ],
                        ),
                        SizedBox(height: 1.0.s),
                        if (isNicknameProven)
                          subtitle
                        else
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              subtitle,
                              SizedBox(width: 4.0.s),
                              Text(context.i18n.nickname_not_owned_suffix),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          OneToOneMessagingContextMenu(
            isBlocked: isBlocked,
            onToggleMute: onToggleMute,
            conversationId: conversationId,
            receiverMasterPubkey: receiverMasterPubkey,
          ),
        ],
      ),
    );
  }
}
