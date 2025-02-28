// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/following_users.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/searched_users.dart';
import 'package:ion/app/features/user/providers/search_users_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class UserPickerSheet extends HookConsumerWidget {
  const UserPickerSheet({
    required this.navigationBar,
    required this.onUserSelected,
    this.header,
    super.key,
    this.selectedPubkeys = const [],
    this.selectable = false,
    this.bottomContent,
  });

  final NavigationAppBar navigationBar;
  final Widget? header;
  final List<String> selectedPubkeys;
  final bool selectable;
  final Widget? bottomContent;
  final void Function(UserMetadataEntity user) onUserSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(searchUsersQueryProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        navigationBar,
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
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
                    children: [
                      header!,
                      SizedBox(height: 12.0.s),
                    ],
                  ),
                if (searchText.isEmpty)
                  FollowingUsers(
                    onUserSelected: onUserSelected,
                    selectedPubkeys: selectedPubkeys,
                    selectable: selectable,
                  )
                else
                  Expanded(
                    child: SearchedUsers(
                      onUserSelected: onUserSelected,
                      selectedPubkeys: selectedPubkeys,
                      selectable: selectable,
                    ),
                  ),
                bottomContent ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
