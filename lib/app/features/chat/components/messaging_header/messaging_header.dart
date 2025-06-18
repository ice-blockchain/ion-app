// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/messages_context_menu/messages_context_menu.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingHeader extends ConsumerWidget {
  const MessagingHeader({
    required this.name,
    required this.subtitle,
    required this.conversationId,
    this.onTap,
    this.imageUrl,
    this.imageWidget,
    this.onToggleMute,
    this.isVerified = false,
    super.key,
  });

  final String name;
  final Widget subtitle;
  final bool isVerified;
  final String? imageUrl;
  final Widget? imageWidget;
  final String conversationId;
  final VoidCallback? onToggleMute;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0.s, 8.0.s, 16.0.s, 12.0.s),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const IconAsset(Assets.svgIconChatBack, size: 24, flipForRtl: true),
          ),
          SizedBox(width: 12.0.s),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
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
                            Expanded(
                              child: Text(
                                name,
                                style: context.theme.appTextThemes.subtitle3,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (isVerified) ...[
                              SizedBox(width: 3.0.s),
                              const IconAsset(Assets.svgIconBadgeVerify, size: 16),
                            ],
                          ],
                        ),
                        SizedBox(height: 1.0.s),
                        subtitle,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          MessagingContextMenu(
            onToggleMute: onToggleMute,
            conversationId: conversationId,
          ),
        ],
      ),
    );
  }
}
