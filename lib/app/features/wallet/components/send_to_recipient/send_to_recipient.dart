import 'package:flutter/material.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';

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
              verifiedBadge: contact!.isVerified!,
              iceBadge: contact!.hasIceAccount,
            ),
            SizedBox(height: 12.0.s),
            Align(
              alignment: Alignment.center,
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
          alignment: Alignment.center,
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
