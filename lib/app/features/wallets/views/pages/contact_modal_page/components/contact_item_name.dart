// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/data/models/user_metadata.c.dart';

class ContactItemName extends StatelessWidget {
  const ContactItemName({
    required this.userMetadata,
    super.key,
  });

  final UserMetadata userMetadata;

  @override
  Widget build(BuildContext context) {
    return Text(
      userMetadata.displayName,
      style: context.theme.appTextThemes.title,
    );
  }
}
