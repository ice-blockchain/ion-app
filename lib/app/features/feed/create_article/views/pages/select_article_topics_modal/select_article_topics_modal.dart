// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:ion/app/features/feed/providers/article/select_topics_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectArticleTopicModal extends HookConsumerWidget {
  const SelectArticleTopicModal({
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

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            onBackPress: () => Navigator.pop(context, false),
            actions: [
              if (selectedTopics.isNotEmpty)
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.s),
                    child: Text(
                      '${context.i18n.topics_add} (${selectedTopics.length})',
                      style: context.theme.appTextThemes.body.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                  ),
                ),
            ],
            title: Text(context.i18n.topics_title),
          ),
          ScreenSideOffset.small(
            child: SearchInput(
              onTextChanged: (String value) {
                searchValue.value = value;
              },
            ),
          ),
          SizedBox(height: 8.0.s),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTopics.length,
              itemBuilder: (BuildContext context, int index) {
                final topic = filteredTopics[index];
                final isSelected = selectedTopics.contains(topic);

                return ListItem(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 8.0.s),
                  constraints: const BoxConstraints(),
                  onTap: () => toggleTopicSelection(topic),
                  backgroundColor: colors.secondaryBackground,
                  trailing: isSelected
                      ? Assets.svgIconBlockCheckboxOnblue.icon(color: colors.success)
                      : Assets.svgIconBlockCheckboxOff.icon(color: colors.tertararyText),
                  title: Text(topic.getTitle(context), style: textStyles.body),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
