// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class RequestContactAccessModal extends ConsumerWidget {
  const RequestContactAccessModal({super.key});

  static double get iceIconSize => 60.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: Padding(
        padding: EdgeInsetsDirectional.only(
          start: ScreenSideOffset.defaultSmallMargin,
          top: 30.0.s,
          end: ScreenSideOffset.defaultSmallMargin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.svg.networks.walletIce.icon(size: iceIconSize),
            SizedBox(
              height: ScreenSideOffset.defaultSmallMargin,
            ),
            Text(
              context.i18n.contacts_allow_pop_up_title,
              style: context.theme.appTextThemes.title.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            SizedBox(
              height: 12.0.s,
            ),
            Text(
              context.i18n.contacts_allow_pop_up_desc,
              textAlign: TextAlign.center,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
            ),
            SizedBox(
              height: 30.0.s,
            ),
            Button(
              mainAxisSize: MainAxisSize.max,
              leadingIcon:
                  Assets.svg.iconButtonInvite.icon(color: context.theme.appColors.onPrimaryAccent),
              label: Text(
                context.i18n.contacts_allow_pop_up_action,
              ),
              onPressed: () async {
                await ref.read(permissionsProvider.notifier).requestPermission(Permission.contacts);

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}
