import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/generated/assets.gen.dart';

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
        verifiedBadge: contact.isVerified!,
        iceBadge: contact.hasIceAccount,
        timeago: contact.lastSeen,
        trailing: IconButton(
          onPressed: onClearTap,
          icon: Assets.images.icons.iconSheetClose.icon(
            size: 16.0.s,
            color: colors.primaryText,
          ),
        ),
        onTap: onContactTap,
      ),
    );
  }
}
