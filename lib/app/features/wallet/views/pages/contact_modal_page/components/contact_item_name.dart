// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/model/contact_data.dart';
import 'package:ion/generated/assets.gen.dart';

class ContactItemName extends StatelessWidget {
  const ContactItemName({
    required this.contactData,
    super.key,
  });

  final ContactData contactData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          contactData.name,
          style: context.theme.appTextThemes.title,
        ),
        if (contactData.isVerified ?? false) ...[
          SizedBox(width: 4.0.s),
          Assets.svg.iconBadgeVerify.icon(size: 16.0.s),
        ],
      ],
    );
  }
}
