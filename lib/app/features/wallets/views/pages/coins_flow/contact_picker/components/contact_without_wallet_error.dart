// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class ContactWithoutWalletError extends StatelessWidget {
  const ContactWithoutWalletError({
    required this.user,
    required this.network,
    super.key,
  });

  final NetworkData network;
  final UserMetadataEntity user;

  @override
  Widget build(BuildContext context) {
    const textSeparator = TextSpan(text: ' ');

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 29.0.s, right: 28.0.s, top: 30.0.s),
              child: InfoCard(
                iconAsset: Assets.svg.actionwalleterrorwallet,
                title: context.i18n.contact_wallet_not_found_title,
                descriptionWidget: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: context.theme.appColors.secondaryText,
                    ),
                    children: [
                      WidgetSpan(
                        child: Avatar(
                          size: 20.0.s,
                          imageUrl: user.data.picture,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      textSeparator,
                      TextSpan(
                        text: user.data.displayName,
                        style: context.theme.appTextThemes.body,
                      ),
                      textSeparator,
                      TextSpan(
                        text: context.i18n.contact_wallet_not_found_description(
                          network.displayName,
                        ),
                        style: context.theme.appTextThemes.body2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0.s),
            ScreenSideOffset.small(
              child: Button(
                label: Text(context.i18n.button_continue),
                mainAxisSize: MainAxisSize.max,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}

Future<void> showContactWithoutWalletError(
  BuildContext context, {
  required NetworkData network,
  required UserMetadataEntity user,
}) {
  return showSimpleBottomSheet<void>(
    context: context,
    child: ContactWithoutWalletError(user: user, network: network),
  );
}
