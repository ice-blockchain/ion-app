// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat-v2/views/components/selectable_user_list_item.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class SelectableUserList extends HookConsumerWidget {
  const SelectableUserList({
    required this.title,
    required this.isLoading,
    required this.selected,
    required this.userEntries,
    required this.onSelect,
    required this.onSearchValueChanged,
    super.key,
  });

  final String title;
  final bool isLoading;
  final List<String> selected;
  final List<UserMetadataEntity> userEntries;
  final void Function(String) onSelect;
  final void Function(String) onSearchValueChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final separatorHeight = 12.0.s;

    final getEntryFirstLetter = useCallback(
      (int index) {
        final entry = userEntries[index];
        return entry.data.displayName.isNotEmpty ? entry.data.displayName[0].toUpperCase() : '#';
      },
      [userEntries],
    );

    final getSectionHeader = useCallback(
      (int index) {
        final firstLetter = getEntryFirstLetter(index);
        if (index == 0) {
          return firstLetter;
        }
        final prevFirstLetter = getEntryFirstLetter(index - 1);
        if (firstLetter != prevFirstLetter) {
          return firstLetter;
        }
        return null;
      },
      [getEntryFirstLetter],
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          primary: false,
          flexibleSpace: NavigationAppBar.modal(
            showBackButton: false,
            actions: const [
              NavigationCloseButton(),
            ],
            title: Text(title),
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: NavigationAppBar.modalHeaderHeight,
          pinned: true,
        ),
        PinnedHeaderSliver(
          child: ScreenSideOffset.small(
            child: Container(
              padding: EdgeInsets.only(bottom: separatorHeight),
              color: context.theme.appColors.secondaryBackground,
              child: SearchInput(
                onTextChanged: onSearchValueChanged,
              ),
            ),
          ),
        ),
        if (isLoading)
          ListItemsLoadingState(
            itemsCount: 11,
            itemHeight: SelectableUserListItem.itemHeight,
            separatorHeight: separatorHeight,
            listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
          )
        else
          SliverList.separated(
            separatorBuilder: (BuildContext _, int __) => SizedBox(height: separatorHeight),
            itemCount: userEntries.length,
            itemBuilder: (BuildContext context, int index) {
              final pubkey = userEntries[index].masterPubkey;
              final sectionHeader = getSectionHeader(index);
              return ScreenSideOffset.small(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sectionHeader != null) ...[
                      Text(sectionHeader),
                      SizedBox(height: separatorHeight),
                    ],
                    SelectableUserListItem(
                      pubkey: pubkey,
                      isSelected: selected.contains(pubkey),
                      onPress: () => onSelect(pubkey),
                    ),
                    if (index == userEntries.length - 1) SizedBox(height: separatorHeight),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
