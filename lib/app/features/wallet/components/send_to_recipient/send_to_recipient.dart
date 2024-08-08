import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contact != null)
          ListItem.user(
            contentPadding: EdgeInsets.only(
              left: ScreenSideOffset.defaultSmallMargin,
              top: 10.0.s,
              bottom: 10.0.s,
              right: 8.0.s,
            ),
            title: Text(contact!.name),
            subtitle: Text(contact!.nickname!),
            profilePicture: contact!.icon,
            verifiedBadge: contact!.isVerified!,
            iceBadge: contact!.hasIceAccount,
            timeago: contact!.lastSeen,
          )
        else
          ListItem.textWithIcon(
            title: Text(locale.wallet_send_to),
            secondary: Align(
              alignment: Alignment.center,
              child: Text(
                address,
                textAlign: TextAlign.center,
                style: context.theme.appTextThemes.caption3.copyWith(),
              ),
            ),
          ),
      ],
    );
  }
}
