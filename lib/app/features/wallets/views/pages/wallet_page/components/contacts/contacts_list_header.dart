// SPDX-License-Identifier: ice License 1.0

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
              final pubkey = await SelectContactRoute().push<String>(context);
              const dialogCloseAnimationDelay = Duration(milliseconds: 500);

              // Wait until close animation finishes
              await Future<void>.delayed(dialogCloseAnimationDelay);

              if (pubkey != null) {
                if (context.mounted) {
                  final needToEnable2FA = await ContactRoute(pubkey: pubkey).push<bool>(context);
                  if (needToEnable2FA != null && needToEnable2FA == true) {
                    await Future<void>.delayed(dialogCloseAnimationDelay);
                    if (context.mounted) {
                      await SecureAccountModalRoute().push<void>(context);
                    }
                  }
                }
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
