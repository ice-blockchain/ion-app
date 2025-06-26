// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/wallets/views/pages/contact_modal_page/components/contact_item_avatar.dart';
import 'package:ion/app/features/wallets/views/pages/contact_modal_page/components/contact_item_name.dart';
import 'package:ion/app/utils/username.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({
    required this.userMetadata,
    super.key,
  });

  final UserMetadataEntity userMetadata;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContactItemAvatar(pubkey: userMetadata.masterPubkey),
        SizedBox(height: 8.0.s),
        ContactItemName(userMetadata: userMetadata.data),
        SizedBox(height: 4.0.s),
        Text(
          prefixUsername(username: userMetadata.data.name, context: context),
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.tertararyText),
        ),
      ],
    );
  }
}
