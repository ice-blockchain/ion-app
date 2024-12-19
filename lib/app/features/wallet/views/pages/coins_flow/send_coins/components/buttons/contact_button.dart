// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/model/contact_data.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ContactButton extends ConsumerWidget {
  const ContactButton({
    required this.contact,
    required this.onContactTap,
    required this.onClearTap,
    super.key,
  });

  final ContactData contact;
  final VoidCallback onContactTap;
  final VoidCallback onClearTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.strokeElements),
        borderRadius: BorderRadius.circular(16.0.s),
        color: colors.secondaryBackground,
      ),
      child: ListItem.user(
        contentPadding: EdgeInsets.only(
          left: ScreenSideOffset.defaultSmallMargin,
          top: 10.0.s,
          bottom: 10.0.s,
          right: 8.0.s,
        ),
        title: Text(contact.name),
        subtitle: Text(contact.nickname!),
        profilePicture: contact.icon,
        timeago: contact.lastSeen,
        trailing: IconButton(
          onPressed: onClearTap,
          icon: Assets.svg.iconSheetClose.icon(
            size: 16.0.s,
            color: colors.primaryText,
          ),
        ),
        onTap: onContactTap,
      ),
    );
  }
}
