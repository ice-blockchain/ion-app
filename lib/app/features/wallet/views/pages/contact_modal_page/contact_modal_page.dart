// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/contact_modal_page/components/contact_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/providers/contacts_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/services/share/share.dart';
import 'package:ice/generated/assets.gen.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({required this.contactId, super.key});

  final String contactId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactData = ref.watch(contactByIdProvider(id: contactId));

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0.s),
                child: ContactItem(
                  contactData: contactData,
                ),
              ),
              if (contactData.hasIceAccount)
                Positioned(
                  top: 16.0.s,
                  right: 16.0.s,
                  child: Button.icon(
                    size: 32.0.s,
                    type: ButtonType.dropdown,
                    onPressed: () {},
                    icon: Assets.svg.iconButtonHistory.icon(),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 20.0.s,
          ),
          if (contactData.hasIceAccount)
            ScreenSideOffset.small(
              child: BalanceActions(
                onReceive: () => ReceiveCoinRoute().push<void>(context),
                onSend: () => CoinSendRoute().push<void>(context),
              ),
            )
          else
            ScreenSideOffset.small(
              child: Button.compact(
                mainAxisSize: MainAxisSize.max,
                minimumSize: Size(56.0.s, 56.0.s),
                leadingIcon: Assets.svg.iconButtonInvite
                    .icon(color: context.theme.appColors.onPrimaryAccent),
                label: Text(
                  context.i18n.wallet_invite_friends,
                ),
                onPressed: () => shareContent('Share', subject: 'Look what I found!'),
              ),
            ),
          ScreenBottomOffset(margin: 32.0.s),
        ],
      ),
    );
  }
}
