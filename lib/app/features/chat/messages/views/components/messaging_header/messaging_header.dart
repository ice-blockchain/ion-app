// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/messages_context_menu/messages_context_menu.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingHeader extends StatelessWidget {
  const MessagingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0.s, 8.0.s, 16.0.s, 12.0.s),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Assets.svg.iconChatBack.icon(size: 24.0.s),
          ),
          SizedBox(width: 12.0.s),
          Avatar(
            size: 36.0.s,
            imageUrl: 'https://i.pravatar.cc/150?u=@anna',
          ),
          SizedBox(width: 10.0.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Selena Maringues',
                    style: context.theme.appTextThemes.subtitle3,
                  ),
                  SizedBox(width: 3.0.s),
                  Assets.svg.iconBadgeVerify.icon(size: 16.0.s),
                ],
              ),
              SizedBox(height: 1.0.s),
              Text(
                '@selenamaringues',
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.quaternaryText,
                ),
              ),
            ],
          ),
          const Spacer(),
          const MessagingContextMenu(),
        ],
      ),
    );
  }
}
