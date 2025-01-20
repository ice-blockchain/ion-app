// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/contact_data.c.dart';

class SendToRecipient extends StatelessWidget {
  const SendToRecipient({
    required this.address,
    this.contact,
    super.key,
  });

  final String address;
  final ContactData? contact;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    if (contact != null) {
      return RoundedCard.filled(
        child: Column(
          children: [
            ListItem.user(
              title: Text(contact!.name),
              subtitle: Text(contact!.nickname!),
              profilePicture: contact!.icon,
            ),
            SizedBox(height: 12.0.s),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                address,
                style: context.theme.appTextThemes.caption3.copyWith(),
              ),
            ),
          ],
        ),
      );
    } else {
      return ListItem.textWithIcon(
        title: Text(locale.wallet_send_to),
        secondary: Align(
          alignment: Alignment.centerRight,
          child: Text(
            address,
            textAlign: TextAlign.center,
            style: context.theme.appTextThemes.caption3.copyWith(),
          ),
        ),
      );
    }
  }
}
