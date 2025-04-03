// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/messages_context_menu/messages_context_menu.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingHeader extends StatelessWidget {
  const MessagingHeader({
    required this.name,
    required this.subtitle,
    this.isVerified = false,
    this.imageUrl,
    this.imageWidget,
    this.onTap,
    super.key,
  });

  final String name;
  final Widget subtitle;
  final bool isVerified;
  final String? imageUrl;
  final Widget? imageWidget;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Avatar(
                  size: 36.0.s,
                  imageUrl: imageWidget != null ? null : imageUrl,
                  imageWidget: imageWidget,
                ),
                SizedBox(width: 10.0.s),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: context.theme.appTextThemes.subtitle3,
                        ),
                        if (isVerified) ...[
                          SizedBox(width: 3.0.s),
                          Assets.svg.iconBadgeVerify.icon(size: 16.0.s),
                        ],
                      ],
                    ),
                    SizedBox(height: 1.0.s),
                    subtitle,
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          const MessagingContextMenu(),
        ],
      ),
    );
  }
}
