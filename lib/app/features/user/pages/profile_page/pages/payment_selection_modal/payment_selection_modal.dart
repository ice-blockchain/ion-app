// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_coin_modal/select_coin_modal.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class PaymentSelectionModal extends StatelessWidget {
  const PaymentSelectionModal({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.common_select_option),
            actions: [
              NavigationCloseButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(
            height: 8.0.s,
          ),
          for (final PaymentType option in PaymentType.values)
            ScreenSideOffset.small(
              child: Column(
                children: [
                  ListItem(
                    title: Text(option.getTitle(context)),
                    subtitle: Text(option.getDesc(context)),
                    backgroundColor: context.theme.appColors.tertararyBackground,
                    leading: option.iconAsset.icon(size: 48.0.s),
                    onTap: () {
                      SelectCoinRoute(
                        paymentType: option,
                        pubkey: pubkey,
                        selectCoinModalType: SelectCoinModalType.select,
                      ).go(context);
                    },
                    trailing: Assets.svg.iconArrowRight.icon(
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                  SizedBox(
                    height: 16.0.s,
                  ),
                ],
              ),
            ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
