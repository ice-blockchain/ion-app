// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_search_modal/components/follower_users.dart';
import 'package:ion/app/features/user/pages/user_search_modal/components/searched_users.dart';
import 'package:ion/app/features/user/providers/search_users_data_source_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class UserSearchModal extends HookConsumerWidget {
  const UserSearchModal({
    required this.navigationBar,
    required this.onUserSelected,
    this.header,
    super.key,
    this.selectedPubkeys,
    this.isMultiple = false,
    this.bottomContent,
  });

  final NavigationAppBar navigationBar;
  final Widget? header;
  final List<String>? selectedPubkeys;
  final bool isMultiple;
  final Widget? bottomContent;
  final void Function(UserMetadataEntity user) onUserSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(searchUsersQueryProvider);

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          navigationBar,
          Expanded(
            child: ScreenSideOffset.small(
              child: Column(
                children: [
                  SearchInput(
                    textInputAction: TextInputAction.search,
                    onTextChanged: (text) {
                      ref.read(searchUsersQueryProvider.notifier).text = text;
                    },
                  ),
                  SizedBox(height: 12.0.s),
                  if (header != null)
                    Column(
                      children: <Widget>[
                        header!,
                        SizedBox(height: 12.0.s),
                      ],
                    ),
                  Expanded(
                    child: searchText.isEmpty
                        ? FollowerUsers(
                            onUserSelected: onUserSelected,
                            selectedPubkeys: selectedPubkeys,
                            isMultiple: isMultiple,
                          )
                        : SearchedUsers(
                            onUserSelected: onUserSelected,
                            selectedPubkeys: selectedPubkeys,
                            isMultiple: isMultiple,
                          ),
                  ),
                  bottomContent ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
