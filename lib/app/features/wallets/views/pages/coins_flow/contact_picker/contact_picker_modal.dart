// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/user_picker_sheet.dart';
import 'package:ion/app/features/wallets/providers/networks_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/contact_without_wallet_error_modal.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum ContactPickerValidatorType { none, networkWallet }

class ContactPickerModal extends ConsumerWidget {
  const ContactPickerModal({
    super.key,
    this.networkId,
    this.validatorType = ContactPickerValidatorType.none,
  });

  final String? networkId;
  final ContactPickerValidatorType validatorType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validator = switch (validatorType) {
      ContactPickerValidatorType.none => (user) async => true,
      ContactPickerValidatorType.networkWallet => (UserMetadataEntity user) async {
          if (networkId == null) return true;

          final network = await ref.read(networkByIdProvider(networkId!).future);
          if (network != null) {
            final address = user.data.wallets?[network.id];
            if (context.mounted) {
              address != null
                  ? context.pop(user.masterPubkey)
                  : showContactWithoutWalletError(
                      context,
                      user: user,
                      network: network,
                    );
            }
          }

          return false;
        },
    };
    return SheetContent(
      topPadding: 0,
      body: UserPickerSheet(
        navigationBar: NavigationAppBar.modal(
          title: Text(context.i18n.friends_modal_title),
          actions: const [NavigationCloseButton()],
        ),
        onUserSelected: (user) async {
          if (await validator(user) && context.mounted) {
            context.pop(user.masterPubkey);
          }
        },
      ),
    );
  }
}
