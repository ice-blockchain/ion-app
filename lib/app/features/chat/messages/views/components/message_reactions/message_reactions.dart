// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

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

class _MessageReactionChip extends ConsumerWidget {
  const _MessageReactionChip({
    required this.emoji,
    required this.pubkeys,
  });

  final String emoji;
  final List<String> pubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPictures = pubkeys
        .map((pubkey) => ref.watch(userMetadataProvider(pubkey)).valueOrNull?.data.picture)
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0.s, horizontal: 6.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryBackground,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: context.theme.appTextThemes.title.copyWith(height: 1)),
          Stack(
            children: [
              //TODO: show only 3 reactions if there are more than 3 reactions when figma is ready
              for (int i = userPictures.length - 1; i >= 0; i--)
                Padding(
                  padding: EdgeInsets.only(left: i * 8.0.s),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.theme.appColors.onPrimaryAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.0.s),
                      child: Avatar(
                        size: 16.0.s,
                        borderRadius: BorderRadius.circular(10),
                        imageUrl: userPictures[i],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
