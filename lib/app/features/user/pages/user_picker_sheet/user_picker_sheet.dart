// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/following_users.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/searched_users.dart';
import 'package:ion/app/features/user/providers/search_users_provider.r.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class UserPickerSheet extends HookConsumerWidget {
  const UserPickerSheet({
    required this.navigationBar,
    required this.onUserSelected,
    super.key,
    this.selectedPubkeys = const [],
    this.selectable = false,
    this.controlPrivacy = false,
    this.header,
    this.footer,
    this.expirationDuration,
  });

  final NavigationAppBar navigationBar;
  final List<String> selectedPubkeys;
  final bool selectable;
  final bool controlPrivacy;
  final Duration? expirationDuration;
  final void Function(UserMetadataEntity user) onUserSelected;

  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchUsersQueryProvider);
    final debouncedQuery = useDebounced(searchQuery, const Duration(milliseconds: 300)) ?? '';

    final searchResults = ref.watch(
      searchUsersProvider(
        query: debouncedQuery,
        expirationDuration: expirationDuration,
      ),
    );

    return LoadMoreBuilder(
      slivers: [
        SliverAppBar(
          primary: false,
          flexibleSpace: navigationBar,
          automaticallyImplyLeading: false,
          toolbarHeight: NavigationAppBar.modalHeaderHeight,
          pinned: true,
        ),
        PinnedHeaderSliver(
          child: ColoredBox(
            color: context.theme.appColors.onPrimaryAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0.s,
                horizontal: ScreenSideOffset.defaultSmallMargin,
              ),
              child: SearchInput(
                textInputAction: TextInputAction.search,
                onTextChanged: (text) {
                  ref.read(searchUsersQueryProvider.notifier).text = text;
                },
              ),
            ),
          ),
        ),
        if (header != null) header!,
        if (debouncedQuery.isEmpty)
          FollowingUsers(
            selectable: selectable,
            onUserSelected: onUserSelected,
            controlChatPrivacy: controlPrivacy,
            selectedPubkeys: selectedPubkeys,
          )
        else
          SearchedUsers(
            selectable: selectable,
            controlChatPrivacy: controlPrivacy,
            onUserSelected: onUserSelected,
            selectedPubkeys: selectedPubkeys,
            users: searchResults.valueOrNull?.users,
          ),
        SliverToBoxAdapter(child: SizedBox(height: 8.0.s)),
        if (footer != null) footer!,
      ],
      onLoadMore: ref.read(searchUsersProvider(query: debouncedQuery).notifier).loadMore,
      hasMore: searchResults.valueOrNull?.hasMore ?? false,
    );
  }
}
