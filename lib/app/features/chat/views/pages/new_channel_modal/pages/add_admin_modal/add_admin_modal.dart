// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/content_creators_data_source_provider.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/add_admin_modal/components/add_admin_list_item.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/generated/assets.gen.dart';

class AddAdminModal extends HookConsumerWidget {
  const AddAdminModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchValue = useState('');
    final selectedPubkey = useState<String?>(null);

    final dataSource = ref.watch(contentCreatorsDataSourceProvider);
    final contentCreators = ref.watch(entitiesPagedDataProvider(dataSource));

    final separatorHeight = 12.0.s;

    final isLoading = contentCreators?.data.items.isEmpty ?? true;
    final userEntries = useMemoized(
      () => (contentCreators?.data.items
              .whereType<UserMetadataEntity>()
              .where(
                (entity) =>
                    entity.data.displayName
                        .toLowerCase()
                        .contains(searchValue.value.toLowerCase()) ||
                    entity.data.name.toLowerCase().contains(searchValue.value.toLowerCase()),
              )
              .toList() ??
          [])
        ..sort(
          (a, b) => a.data.displayName.toLowerCase().compareTo(b.data.displayName.toLowerCase()),
        ),
      [contentCreators, searchValue.value],
    );

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

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  primary: false,
                  flexibleSpace: NavigationAppBar.modal(
                    showBackButton: false,
                    actions: [
                      NavigationCloseButton(
                        onPressed: () => context.pop(),
                      ),
                    ],
                    title: Text(context.i18n.channel_create_admins_action),
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
                        onTextChanged: (text) {
                          searchValue.value = text;
                        },
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  ListItemsLoadingState(
                    itemsCount: 11,
                    itemHeight: AddAdminListItem.itemHeight,
                    separatorHeight: separatorHeight,
                    listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
                  )
                else
                  SliverList.separated(
                    separatorBuilder: (BuildContext _, int __) => SizedBox(height: separatorHeight),
                    itemCount: userEntries.length,
                    itemBuilder: (BuildContext context, int index) {
                      final pubkey = userEntries[index].pubkey;
                      final sectionHeader = getSectionHeader(index);
                      return ScreenSideOffset.small(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sectionHeader != null) ...[
                              Text(sectionHeader),
                              SizedBox(height: separatorHeight),
                            ],
                            AddAdminListItem(
                              pubkey: pubkey,
                              isSelected: selectedPubkey.value == pubkey,
                              onPress: () => selectedPubkey.value = pubkey,
                            ),
                            if (index == userEntries.length - 1) SizedBox(height: separatorHeight),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          const HorizontalSeparator(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0.s,
              horizontal: 44.0.s,
            ),
            child: Button(
              type: selectedPubkey.value == null ? ButtonType.disabled : ButtonType.primary,
              mainAxisSize: MainAxisSize.max,
              minimumSize: Size(56.0.s, 56.0.s),
              leadingIcon: Assets.svg.iconProfileSave.icon(
                color: context.theme.appColors.onPrimaryAccent,
              ),
              label: Text(
                context.i18n.button_confirm,
              ),
              onPressed: () {
                ref
                    .read(channelAdminsProvider.notifier)
                    .setAdmin(selectedPubkey.value!, ChannelAdminType.admin);
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
