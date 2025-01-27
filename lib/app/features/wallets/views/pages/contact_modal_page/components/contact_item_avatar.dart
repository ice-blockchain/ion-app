// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';

class ContactItemAvatar extends StatelessWidget {
  const ContactItemAvatar({
    required this.userMetadata,
    super.key,
  });

  final UserMetadata userMetadata;

  static double get imageWidth => 60.0.s;

  @override
  Widget build(BuildContext context) {
    return Avatar(
      size: imageWidth,
      imageUrl: userMetadata.picture,
      borderRadius: BorderRadius.circular(14.0.s),
    );
  }
}
