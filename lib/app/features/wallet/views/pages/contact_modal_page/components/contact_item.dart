// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/contact_data.dart';
import 'package:ion/app/features/wallet/views/pages/contact_modal_page/components/contact_item_avatar.dart';
import 'package:ion/app/features/wallet/views/pages/contact_modal_page/components/contact_item_name.dart';
import 'package:ion/app/utils/username.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({
    required this.contactData,
    super.key,
  });

  final ContactData contactData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContactItemAvatar(contactData: contactData),
        SizedBox(height: 8.0.s),
        ContactItemName(contactData: contactData),
        SizedBox(height: 4.0.s),
        Text(
          contactData.hasIceAccount
              ? prefixUsername(
                  username: contactData.nickname,
                  context: context,
                )
              : contactData.phoneNumber ?? '',
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.tertararyText),
        ),
        if (!contactData.hasIceAccount) SizedBox(height: 34.0.s),
        if (!contactData.hasIceAccount)
          Text(
            context.i18n.wallet_friends_does_not_have_account,
            style: context.theme.appTextThemes.subtitle2,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
