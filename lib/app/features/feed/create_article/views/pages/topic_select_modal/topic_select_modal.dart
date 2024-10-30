// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/topic_type.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class TopicSelectModal extends HookConsumerWidget {
  const TopicSelectModal({
    required this.selectedTopics,
    super.key,
  });

  final List<TopicType> selectedTopics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;
    final searchValue = useState('');
    final selectedTopicTypes = useState<List<TopicType>>(
      List.from(selectedTopics),
    );

    final filteredTopics = useMemoized(
      () {
        final query = searchValue.value.toLowerCase();
        return TopicType.values.where((topic) {
          final title = topic.getTitle(context).toLowerCase();
          return title.contains(query);
        }).toList();
      },
      [searchValue.value],
    );

    void toggleTopicSelection(TopicType topic) {
      if (selectedTopicTypes.value.contains(topic)) {
        selectedTopicTypes.value = List.from(selectedTopicTypes.value)..remove(topic);
      } else {
        selectedTopicTypes.value = List.from(selectedTopicTypes.value)..add(topic);
      }
    }

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              actions: [
                if (selectedTopicTypes.value.isNotEmpty)
                  Text(
                    '${context.i18n.topics_add} (${selectedTopicTypes.value.length})',
                    style: context.theme.appTextThemes.body.copyWith(
                      color: context.theme.appColors.primaryAccent,
                    ),
                  ),
              ],
              title: Text(context.i18n.topics_title),
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
                final isSelected = selectedTopicTypes.value.contains(topic);

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
