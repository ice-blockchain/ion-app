// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/contact_data.c.dart';

class ContactItemName extends StatelessWidget {
  const ContactItemName({
    required this.contactData,
    super.key,
  });

  final ContactData contactData;

  @override
  Widget build(BuildContext context) {
    return Text(
      contactData.name,
      style: context.theme.appTextThemes.title,
    );
  }
}
