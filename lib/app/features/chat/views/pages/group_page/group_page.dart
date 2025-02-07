// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';

class GroupPage extends ConsumerWidget {
  const GroupPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = <MessageListItem>[];

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
        ),
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ChatMessagesList(
                messages,
                displayAuthorsIncomingMessages: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
