// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/recent_emoji_reactions_provider.dart';
import 'package:ion/app/features/core/model/emoji/emoji_category.dart';
import 'package:ion/app/features/core/providers/emoji/emoji_set_provider.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class SearchEmojiModal extends ConsumerWidget {
  const SearchEmojiModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiGroups = ref.watch(emojisFilteredByQueryProvider);
    final recentEmojiReactions = ref.read(recentEmojiReactionsProvider);

    return SheetContent(
      body: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: const Text('Emoji'),
              showBackButton: false,
              actions: [
                NavigationCloseButton(
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            ),
            SearchInput(
              onTextChanged: (value) {
                ref.read(emojiSearchQueryProvider.notifier).query = value;
              },
            ),
            if (emojiGroups.hasValue)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0.s, bottom: 10.0.s),
                  itemCount: emojiGroups.value!.length,
                  itemBuilder: (context, index) {
                    final group = emojiGroups.value![index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (recentEmojiReactions.isNotEmpty && index == 0)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0.s),
                                child: Text(
                                  context.i18n.recent_emoji_reactions,
                                  style: context.theme.appTextThemes.body2.copyWith(
                                    color: context.theme.appColors.tertararyText,
                                  ),
                                ),
                              ),
                              GridView.count(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 8,
                                mainAxisSpacing: 16.0.s,
                                crossAxisSpacing: 16.0.s,
                                children: recentEmojiReactions
                                    .map(
                                      (reaction) => GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(recentEmojiReactionsProvider.notifier)
                                              .addEmoji(reaction);
                                          context.pop();
                                        },
                                        child: Text(
                                          reaction,
                                          style: context.theme.appTextThemes.headline1.copyWith(
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 24.0.s, bottom: 10.0.s),
                          child: Text(
                            EmojiCategory.fromSlug(group.slug).getTitle(context),
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: context.theme.appColors.tertararyText,
                            ),
                          ),
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 8,
                          mainAxisSpacing: 16.0.s,
                          crossAxisSpacing: 16.0.s,
                          children: group.emojis
                              .map(
                                (emoji) => Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(recentEmojiReactionsProvider.notifier)
                                          .addEmoji(emoji.emoji);
                                      context.pop();
                                    },
                                    child: Text(
                                      emoji.emoji,
                                      style: context.theme.appTextThemes.headline1.copyWith(
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
