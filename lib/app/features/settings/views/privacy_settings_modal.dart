// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/settings/components/selectable_options_group.dart';
import 'package:ion/app/features/settings/model/privacy_options.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/update_user_metadata_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class PrivacySettingsModal extends ConsumerWidget {
  const PrivacySettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = ref.watch(currentUserMetadataProvider).valueOrNull;

    ref.displayErrors(updateUserMetadataNotifierProvider);

    if (metadata == null) {
      return const SizedBox.shrink();
    }

    final walletPrivacy = WalletAddressPrivacyOption.fromWalletsMap(metadata.data.wallets);
    final messagingPrivacy =
        UserVisibilityPrivacyOption.fromWhoCanSetting(metadata.data.whoCanMessageYou);
    final invitingPrivacy =
        UserVisibilityPrivacyOption.fromWhoCanSetting(metadata.data.whoCanInviteYouToGroups);

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: Text(context.i18n.settings_privacy),
              actions: const [
                NavigationCloseButton(),
              ],
            ),
            ScreenSideOffset.small(
              child: ScreenBottomOffset(
                margin: 32.0.s,
                child: SeparatedColumn(
                  mainAxisSize: MainAxisSize.min,
                  separator: SelectableOptionsGroup.separator,
                  children: [
                    SelectableOptionsGroup(
                      title: context.i18n.privacy_group_wallet_address_title,
                      selected: [walletPrivacy],
                      options: WalletAddressPrivacyOption.values,
                      onSelected: (option) => ref
                          .read(updateUserMetadataNotifierProvider.notifier)
                          .publishWallets(option),
                    ),
                    SelectableOptionsGroup(
                      title: context.i18n.privacy_group_who_can_message_you_title,
                      selected: [messagingPrivacy],
                      options: UserVisibilityPrivacyOption.values,
                      onSelected: (option) =>
                          _onMessagingPrivacyOptionSelected(ref, metadata, option),
                    ),
                    SelectableOptionsGroup(
                      title: context.i18n.privacy_group_who_can_invite_you_title,
                      selected: [invitingPrivacy],
                      options: UserVisibilityPrivacyOption.values,
                      onSelected: (option) =>
                          _onInvitingPrivacyOptionSelected(ref, metadata, option),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMessagingPrivacyOptionSelected(
    WidgetRef ref,
    UserMetadataEntity metadata,
    UserVisibilityPrivacyOption option,
  ) {
    final updatedMetadata = metadata.data.copyWith(whoCanMessageYou: option.toWhoCanSetting());
    ref.read(updateUserMetadataNotifierProvider.notifier).publish(updatedMetadata);
  }

  void _onInvitingPrivacyOptionSelected(
    WidgetRef ref,
    UserMetadataEntity metadata,
    UserVisibilityPrivacyOption option,
  ) {
    final updatedMetadata =
        metadata.data.copyWith(whoCanInviteYouToGroups: option.toWhoCanSetting());
    ref.read(updateUserMetadataNotifierProvider.notifier).publish(updatedMetadata);
  }
}
