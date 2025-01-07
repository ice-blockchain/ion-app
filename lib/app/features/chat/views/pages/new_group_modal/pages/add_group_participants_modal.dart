// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/create_group_form_controller_provider.c.dart';
import 'package:ion/app/features/user/pages/user_search_modal/user_search_modal.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class AddGroupParticipantsModal extends HookConsumerWidget {
  const AddGroupParticipantsModal({super.key});

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final createGroupForm = ref.watch(createGroupFormControllerProvider);
  //   final createGroupFormNotifier = ref.read(createGroupFormControllerProvider.notifier);

  //   final searchValue = useState('');

  //   final dataSource = ref.watch(contentCreatorsDataSourceProvider);
  //   final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
  //   final contentCreators = entitiesPagedData?.data.items;

  //   final isLoading = contentCreators?.isEmpty ?? true;

  //   // TODO: Replace stub with implemented search
  //   final userEntries = useMemoized(
  //     () => (contentCreators
  //             ?.whereType<UserMetadataEntity>()
  //             .where(
  //               (entity) =>
  //                   entity.data.displayName
  //                       .toLowerCase()
  //                       .contains(searchValue.value.toLowerCase()) ||
  //                   entity.data.name.toLowerCase().contains(searchValue.value.toLowerCase()),
  //             )
  //             .toList() ??
  //         [])
  //       ..sort(
  //         (a, b) => a.data.displayName.toLowerCase().compareTo(b.data.displayName.toLowerCase()),
  //       ),
  //     [contentCreators, searchValue.value],
  //   );

  //   return SheetContent(
  //     topPadding: 0,
  //     body: Column(
  //       children: [
  //         Expanded(
  //           child: SelectableUserList(
  //             title: context.i18n.group_create_title,
  //             isLoading: isLoading,
  //             userEntries: userEntries,
  //             selected: createGroupForm.members.toList(),
  //             onSelect: createGroupFormNotifier.toggleMember,
  //             onSearchValueChanged: (String value) => searchValue.value = value,
  //           ),
  //         ),
  //         const HorizontalSeparator(),
  //         ScreenBottomOffset(
  //           margin: 32.0.s,
  //           child: Padding(
  //             padding: EdgeInsets.only(top: 16.0.s),
  //             child: ScreenSideOffset.large(
  //               child: Button(
  //                 onPressed: () {
  //                   CreateGroupModalRoute().push<void>(context);
  //                 },
  //                 label: Text(context.i18n.button_next),
  //                 mainAxisSize: MainAxisSize.max,
  //                 trailingIcon: Assets.svg.iconButtonNext.icon(
  //                   color: context.theme.appColors.onPrimaryAccent,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createGroupForm = ref.watch(createGroupFormControllerProvider);
    final createGroupFormNotifier = ref.read(createGroupFormControllerProvider.notifier);

    return UserSearchModal(
      key: const Key('add-group-participants-modal'),
      selectedPubkeys: createGroupForm.members.toList(),
      isMultiple: true,
      onUserSelected: (user) {
        createGroupFormNotifier.toggleMember(user.masterPubkey);
      },
      navigationBar: NavigationAppBar.modal(
        title: Text(context.i18n.group_create_title),
        showBackButton: false,
        actions: [
          NavigationCloseButton(
            onPressed: Navigator.of(context, rootNavigator: true).pop,
          ),
        ],
      ),
    );
  }
}
