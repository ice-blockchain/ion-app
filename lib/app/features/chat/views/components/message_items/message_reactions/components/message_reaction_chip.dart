// SPDX-License-Identifier: ice License 1.0

part of '../message_reactions.dart';

class _MessageReactionChip extends HookConsumerWidget {
  const _MessageReactionChip({
    required this.isMe,
    required this.emoji,
    required this.pubkeys,
    required this.eventMessageId,
  });

  final bool isMe;
  final String emoji;
  final List<String> pubkeys;
  final String eventMessageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPubKey = ref.watch(currentPubkeySelectorProvider);

    final isCurrentUserHasReaction = useMemoized(
      () => pubkeys.contains(currentPubKey),
      [pubkeys, currentPubKey],
    );

    return GestureDetector(
      onTap: () {
        final userMasterPubkey = ref.read(currentPubkeySelectorProvider);

        if (userMasterPubkey == null) return;

        ref.read(conversationMessageReactionDaoProvider).remove(
              content: emoji,
              masterPubkey: userMasterPubkey,
              eventMessageId: eventMessageId,
            );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0.s, horizontal: 6.0.s),
        decoration: BoxDecoration(
          color: isCurrentUserHasReaction & !isMe
              ? context.theme.appColors.primaryAccent
              : context.theme.appColors.primaryBackground,
          borderRadius: BorderRadius.circular(10.0.s),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: context.theme.appTextThemes.title.copyWith(height: 1)),
            _AvatarStack(pubkeys: pubkeys),
          ],
        ),
      ),
    );
  }
}

class _AvatarStack extends ConsumerWidget {
  const _AvatarStack({
    required this.pubkeys,
  });

  final List<String> pubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        //TODO: show only 3 reactions if there are more than 3 reactions when figma is ready
        for (int i = pubkeys.length - 1; i >= 0; i--)
          Builder(
            builder: (context) {
              final userPicture =
                  ref.watch(userMetadataProvider(pubkeys[i])).valueOrNull?.data.picture;
              return Padding(
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
                      imageUrl: userPicture,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
