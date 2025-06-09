// SPDX-License-Identifier: ice License 1.0

part of '../search_emoji_modal.dart';

class _EmojisGridView extends ConsumerWidget {
  const _EmojisGridView({
    required this.emojis,
    required this.title,
  });

  final List<String> emojis;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
        ),
        GridView.count(
          padding: EdgeInsetsDirectional.only(top: 10.0.s),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 8,
          mainAxisSpacing: 16.0.s,
          crossAxisSpacing: 8.0.s,
          children: emojis
              .map(
                (emoji) => Center(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(recentEmojiReactionsProvider.notifier).addEmoji(emoji);
                      context.pop<String>(emoji);
                    },
                    child: Text(
                      emoji,
                      style: context.theme.appTextThemes.headline1
                          .copyWith(
                            height: 1,
                          )
                          .platformEmojiAware(),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
