import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class NostrAuth extends IceSimplePage {
  const NostrAuth(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Scaffold(
      body: ScreenSideOffset.large(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AuthHeaderWidget(
              title: context.i18n.nostr_auth_title,
              description: context.i18n.nostr_auth_description,
            ),
            Image.asset(
              Assets.images.bg.ostrichlogo.path,
              width: 256.0.s,
              height: 160.0.s,
            ),
            Column(
              children: <Widget>[
                Center(
                  child: Button(
                    leadingIcon: Assets.images.icons.iconLoginCreateacc.icon(),
                    onPressed: () {
                      // showModalScreen(
                      //   const NostrCreateAccount(),
                      //   context,
                      // );
                    },
                    type: ButtonType.outlined,
                    label: Text(context.i18n.button_create_account),
                    mainAxisSize: MainAxisSize.max,
                  ),
                ),
                SizedBox(
                  height: 26.0.s,
                ),
                Center(
                  child: Button(
                    leadingIcon: Assets.images.icons.iconProfileSave.icon(),
                    onPressed: () {
                      IceRoutes.nostrLogin.go(context);
                    },
                    label: Text(context.i18n.button_login),
                    mainAxisSize: MainAxisSize.max,
                  ),
                ),
                SizedBox(
                  height: 91.0.s,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
