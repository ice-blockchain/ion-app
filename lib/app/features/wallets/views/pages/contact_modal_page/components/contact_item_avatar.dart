// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/contact_data.c.dart';

class ContactItemAvatar extends StatelessWidget {
  const ContactItemAvatar({
    required this.contactData,
    super.key,
  });

  final ContactData contactData;

  static double get imageWidth => 60.0.s;

  @override
  Widget build(BuildContext context) {
    return Avatar(
      size: imageWidth,
      imageUrl: contactData.icon,
      borderRadius: BorderRadius.circular(14.0.s),
    );
  }
}
