import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class RequestContactAccessModal extends IceSimplePage {
  const RequestContactAccessModal(super.route, super.payload);

  static double get iceIconSize => 60.0.s;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Column(
      children: <Widget>[
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.s)),
          child: ColoredBox(
            color: context.theme.appColors.primaryBackground,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  ScreenSideOffset.defaultSmallMargin,
                  30.0.s,
                  ScreenSideOffset.defaultSmallMargin,
                  ScreenSideOffset.defaultSmallMargin,
                ),
                child: Column(
                  children: <Widget>[
                    Assets.images.wallet.walletIce
                        .image(width: iceIconSize, height: iceIconSize),
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
                      leadingIcon: Assets.images.icons.iconButtonInvite.icon(),
                      label: Text(
                        context.i18n.contacts_allow_pop_up_action,
                      ),
                      onPressed: () {
                        ref
                            .read(permissionsProvider.notifier)
                            .requestContactsPermission();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
