// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat-v2/model/message_reaction_group.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

part 'components/message_reaction_chip.dart';

class MessageReactions extends StatelessWidget {
  const MessageReactions({required this.reactions, super.key});

  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context) {
    if (reactions == null || reactions!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 8.0.s),
      child: Wrap(
        spacing: 4.0.s,
        runSpacing: 4.0.s,
        children: reactions!
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
}
