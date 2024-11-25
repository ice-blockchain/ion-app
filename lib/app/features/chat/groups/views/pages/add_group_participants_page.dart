// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/groups/model/alphabetical_list_item.dart';
import 'package:ion/app/features/chat/groups/model/user.dart';
import 'package:ion/app/features/chat/groups/providers/alphabetical_list_provider.dart';
import 'package:ion/app/features/chat/groups/providers/create_group_form_controller_provider.dart';
import 'package:ion/app/features/chat/groups/providers/group_search_participants_provider.dart';
import 'package:ion/app/features/chat/groups/views/components/alphabetical_list_item_widget.dart';
import 'package:ion/app/features/search/views/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class AddGroupParticipantsPage extends HookConsumerWidget {
  const AddGroupParticipantsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState<String>('');
    final createGroupForm = ref.watch(createGroupFormControllerProvider);

    // TODO: Replace with the correct provider when implemented
    final participantsSearchResults = ref.watch(
      groupSearchParticipantsProvider(searchQuery.value),
    );

    final transformedResult = ref.watch(
      transformWithAlphabeticalHeadersProvider(
        input: participantsSearchResults.value,
      ),
    );

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: const Text('New group'),
            actions: [
              NavigationCloseButton(
                onPressed: Navigator.of(context, rootNavigator: true).pop,
              ),
            ],
          ),
          SizedBox(height: 9.0.s),
          ScreenSideOffset.small(
            child: Column(
              children: [
                SearchInput(
                  textInputAction: TextInputAction.search,
                  onTextChanged: (value) => searchQuery.value = value,
                ),
                SizedBox(height: 16.0.s),
              ],
            ),
          ),
          Expanded(
            child: ScreenSideOffset.small(
              child: transformedResult.maybeMap(
                data: (data) => _SearchResults(
                  searchResults: data.value,
                  selected: createGroupForm.members.toList(),
                  toggleSelection: (user) =>
                      ref.read(createGroupFormControllerProvider.notifier).toggleMember(user),
                ),
                orElse: () => const SizedBox(),
              ),
            ),
          ),
          const HorizontalSeparator(),
          ScreenBottomOffset(
            margin: 32.0.s,
            child: Padding(
              padding: EdgeInsets.only(top: 16.0.s),
              child: ScreenSideOffset.large(
                child: Button(
                  onPressed: () {
                    CreateGroupModalRoute().push<void>(context);
                  },
                  label: const Text('Next'),
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.searchResults,
    required this.selected,
    required this.toggleSelection,
  });

  final List<User> selected;
  final void Function(User) toggleSelection;
  final List<AlphabeticalListItem>? searchResults;

  @override
  Widget build(BuildContext context) {
    // Created to avoid null-assertion
    final results = searchResults;

    if (results == null) {
      return const SizedBox();
    }

    if (results.isEmpty) {
      return NothingIsFound(
        title: context.i18n.core_empty_search,
      );
    }

    return ListView.separated(
      itemBuilder: (_, i) {
        final item = results[i];
        return AlphabeticalListItemWidget(
          item: item,
          onUserItemTap: (item) => toggleSelection(item.user),
          isUserSelected: (item) => selected.contains(item.user),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 12.0.s),
      itemCount: results.length,
    );
  }
}
