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
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: 16.0.s, bottom: 10.0.s),
          child: Text(
            title,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.quaternaryText,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: emojis.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 16.0.s,
            crossAxisSpacing: 8.0.s,
          ),
          itemBuilder: (context, index) {
            final emoji = emojis[index];
            return Center(
              child: GestureDetector(
                onTap: () {
                  ref.read(recentEmojiReactionsProvider.notifier).addEmoji(emoji);
                  context.pop<String>(emoji);
                },
                child: Text(
                  emoji,
                  style: context.theme.appTextThemes.headline1.copyWith(
                    height: 1,
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
