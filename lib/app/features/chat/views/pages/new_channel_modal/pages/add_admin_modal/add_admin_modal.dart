// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/content_creators_data_source_provider.c.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/chat/views/components/selectable_user_list.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
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
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final contentCreators = entitiesPagedData?.data.items;

    final isLoading = contentCreators?.isEmpty ?? true;
    final userEntries = useMemoized(
      () => (contentCreators
              ?.whereType<UserMetadataEntity>()
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

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: SelectableUserList(
              title: context.i18n.channel_create_admins_action,
              isLoading: isLoading,
              selected: [
                if (selectedPubkey.value != null) selectedPubkey.value!,
              ],
              userEntries: userEntries,
              onSelect: (String value) => selectedPubkey.value = value,
              onSearchValueChanged: (String value) => searchValue.value = value,
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
                    .read(channelAdminsProvider().notifier)
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
