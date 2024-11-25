// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:ion/app/features/feed/providers/article/select_topics_provider.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/generated/assets.gen.dart';

class TopicSelectModal extends HookConsumerWidget {
  const TopicSelectModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopics = ref.watch(selectTopicsProvider);
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;
    final searchValue = useState('');

    final filteredTopics = useMemoized(
      () {
        final query = searchValue.value.toLowerCase();
        return ArticleTopic.values.where((topic) {
          final title = topic.getTitle(context).toLowerCase();
          return title.contains(query);
        }).toList();
      },
      [searchValue.value],
    );

    void toggleTopicSelection(ArticleTopic topic) {
      final notifier = ref.read(selectTopicsProvider.notifier);
      if (selectedTopics.contains(topic)) {
        notifier.selectTopics = List.from(selectedTopics)..remove(topic);
      } else {
        notifier.selectTopics = List.from(selectedTopics)..add(topic);
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              onBackPress: () => Navigator.pop(context, false),
              actions: [
                if (selectedTopics.isNotEmpty)
                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Text(
                      '${context.i18n.topics_add} (${selectedTopics.length})',
                      style: context.theme.appTextThemes.body.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                  ),
              ],
              title: Text(
                context.i18n.topics_title,
                style: context.theme.appTextThemes.subtitle,
              ),
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            pinned: true,
          ),
          PinnedHeaderSliver(
            child: ColoredBox(
              color: context.theme.appColors.onPrimaryAccent,
              child: Column(
                children: [
                  SizedBox(height: 16.0.s),
                  ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) {
                        searchValue.value = value;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final topic = filteredTopics[index];
                final isSelected = selectedTopics.contains(topic);

                return MenuItemButton(
                  onPressed: () => toggleTopicSelection(topic),
                  trailingIcon: isSelected
                      ? Assets.svg.iconBlockCheckboxOnblue.icon(
                          color: colors.success,
                        )
                      : Assets.svg.iconBlockCheckboxOff.icon(
                          color: colors.tertararyText,
                        ),
                  child: Text(
                    topic.getTitle(context),
                    style: textStyles.body,
                  ),
                );
              },
              childCount: filteredTopics.length,
            ),
          ),
        ],
      ),
    );
  }
}
