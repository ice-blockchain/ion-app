// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/contact_modal_page/components/contact_item.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey)).valueOrNull;

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0.s),
                child: ContactItem(userMetadata: userMetadata.data),
              ),
            ],
          ),
          SizedBox(height: 20.0.s),
          ScreenSideOffset.small(
            child: BalanceActions(
              onReceive: () => ReceiveCoinRoute().push<void>(context),
              onSend: () {
                ref.invalidate(sendAssetFormControllerProvider());
                ref.read(sendAssetFormControllerProvider().notifier).setContact(pubkey);

                CoinSendRoute().push<void>(context);
              },
              onNeedToEnable2FA: () => Navigator.of(context).pop(true),
            ),
          ),
          ScreenBottomOffset(margin: 32.0.s),
        ],
      ),
    );
  }
}
