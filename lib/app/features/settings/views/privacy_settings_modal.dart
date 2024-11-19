// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/settings/components/selectable_options_group.dart';
import 'package:ion/app/features/settings/model/privacy_options.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class PrivacySettingsModal extends HookConsumerWidget {
  const PrivacySettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace it with logic implementation
    final walletPrivacy = useState<WalletAddressPrivacyOption>(
      WalletAddressPrivacyOption.public,
    );
    final messagingPrivacy = useState<UserVisibilityPrivacyOption>(
      UserVisibilityPrivacyOption.everyone,
    );
    final invitingPrivacy = useState<UserVisibilityPrivacyOption>(
      UserVisibilityPrivacyOption.everyone,
    );

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.settings_privacy),
            actions: [
              NavigationCloseButton(
                onPressed: Navigator.of(context, rootNavigator: true).pop,
              ),
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
                    selected: [walletPrivacy.value],
                    options: WalletAddressPrivacyOption.values,
                    onSelected: (option) => walletPrivacy.value = option,
                  ),
                  SelectableOptionsGroup(
                    title: context.i18n.privacy_group_who_can_message_you_title,
                    selected: [messagingPrivacy.value],
                    options: UserVisibilityPrivacyOption.values,
                    onSelected: (option) => messagingPrivacy.value = option,
                  ),
                  SelectableOptionsGroup(
                    title: context.i18n.privacy_group_who_can_invite_you_title,
                    selected: [invitingPrivacy.value],
                    options: UserVisibilityPrivacyOption.values,
                    onSelected: (option) => invitingPrivacy.value = option,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
