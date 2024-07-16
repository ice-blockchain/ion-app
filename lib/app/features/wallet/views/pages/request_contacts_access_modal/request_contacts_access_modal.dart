import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RequestContactAccessModal extends IcePage {
  const RequestContactAccessModal({super.key});

  static double get iceIconSize => 60.0.s;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          ScreenSideOffset.defaultSmallMargin,
          30.0.s,
          ScreenSideOffset.defaultSmallMargin,
          ScreenSideOffset.defaultSmallMargin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Assets.images.wallet.walletIce.icon(size: iceIconSize),
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
              leadingIcon: Assets.images.icons.iconButtonInvite
                  .icon(color: context.theme.appColors.onPrimaryAccent),
              label: Text(
                context.i18n.contacts_allow_pop_up_action,
              ),
              onPressed: () {
                ref
                    .read(permissionsProvider.notifier)
                    .requestPermission(PermissionType.Contacts)
                    .then((_) {
                  Navigator.of(context).pop();
                });
              },
            ),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}
