import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/one_contact_modal_page/components/one_contact_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/share.dart';
import 'package:ice/generated/assets.gen.dart';

class OneContactView extends IcePage {
  const OneContactView({required this.contactData, super.key});

  final ContactData contactData;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0.s),
                child: OneContactItem(
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
                    icon: Assets.images.icons.iconButtonHistory.image(),
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
                leadingIcon: Assets.images.icons.iconButtonInvite
                    .icon(color: context.theme.appColors.onPrimaryAccent),
                label: Text(
                  context.i18n.wallet_invite_friends,
                ),
                onPressed: () =>
                    shareContent('Share', subject: 'Look what I found!'),
              ),
            ),
          SizedBox(
            height: 12.0.s,
          ),
        ],
      ),
    );
  }
}
