// SPDX-License-Identifier: ice License 1.0

part of '../message_reactions.dart';

class _MessageReactionChip extends HookConsumerWidget {
  const _MessageReactionChip({
    required this.onTap,
    required this.isMe,
    required this.emoji,
    required this.masterPubkeys,
    required this.currentUserHasReaction,
  });

  final bool isMe;
  final String emoji;
  final List<String> masterPubkeys;
  final bool currentUserHasReaction;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0.s, horizontal: 6.0.s),
        decoration: BoxDecoration(
          color: currentUserHasReaction & !isMe
              ? context.theme.appColors.primaryAccent
              : context.theme.appColors.primaryBackground,
          borderRadius: BorderRadius.circular(10.0.s),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: context.theme.appTextThemes.title.copyWith(height: 1)),
            _AvatarStack(pubkeys: masterPubkeys),
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.0.s),
                    child: Avatar(
                      size: 16.0.s,
                      borderRadius: BorderRadius.circular(5),
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
