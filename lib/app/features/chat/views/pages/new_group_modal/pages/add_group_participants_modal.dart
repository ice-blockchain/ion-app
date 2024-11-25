// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/content_creators_data_source_provider.dart';
import 'package:ion/app/features/chat/providers/create_group_form_controller_provider.dart';
import 'package:ion/app/features/chat/views/components/selectable_user_list.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class AddGroupParticipantsModal extends HookConsumerWidget {
  const AddGroupParticipantsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createGroupForm = ref.watch(createGroupFormControllerProvider);
    final createGroupFormNotifier = ref.read(createGroupFormControllerProvider.notifier);

    final searchValue = useState('');

    final dataSource = ref.watch(contentCreatorsDataSourceProvider);
    final contentCreators = ref.watch(entitiesPagedDataProvider(dataSource));

    final isLoading = contentCreators?.data.items.isEmpty ?? true;

    // TODO: Replace stub with implemented search
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

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          Expanded(
            child: SelectableUserList(
              title: context.i18n.group_create_title,
              isLoading: isLoading,
              userEntries: userEntries,
              selected: createGroupForm.members.toList(),
              onSelect: createGroupFormNotifier.toggleMember,
              onSearchValueChanged: (String value) => searchValue.value = value,
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
                  label: Text(context.i18n.group_create_next_button),
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
