// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

part 'components/message_reaction_chip.dart';

class MessageReactions extends ConsumerWidget {
  const MessageReactions({required this.entity, super.key});

  final PrivateDirectMessageEntity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactions = ref.watch(conversationMessageReactionDaoProvider).messageReactions(entity);

    return StreamBuilder<List<MessageReactionGroup>>(
      stream: reactions,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0.s),
            child: Wrap(
              spacing: 4.0.s,
              runSpacing: 4.0.s,
              children: snapshot.data!
                  .map(
                    (reaction) => _MessageReactionChip(
                      emoji: reaction.emoji,
                      pubkeys: reaction.pubkeys,
                    ),
                  )
                  .toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
