// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ContactListHeader extends StatelessWidget {
  const ContactListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenSideOffset.defaultSmallMargin,
        right: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
        top: 16.0.s - UiConstants.hitSlop,
        bottom: 14.0.s - UiConstants.hitSlop,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.i18n.friends_title,
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
          TextButton(
            onPressed: () async {
              final pubkey = await NftSelectFriendRoute().push<String>(context);
              if (pubkey != null && context.mounted) {
                unawaited(ContactRoute(contactId: pubkey).push<void>(context));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(UiConstants.hitSlop),
              child: Text(
                context.i18n.core_view_all,
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.primaryAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
