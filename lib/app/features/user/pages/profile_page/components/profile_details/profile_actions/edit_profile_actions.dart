// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/edit_user_button.dart';

class EditProfileActions extends StatelessWidget {
  const EditProfileActions({
    required this.pubkey,
    super.key,
  });

  double get pictureSize => 100.0.s;

  double get pictureBorderWidth => 5.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EditUserButton(
          pupkey: pubkey,
        ),
      ],
    );
  }
}
