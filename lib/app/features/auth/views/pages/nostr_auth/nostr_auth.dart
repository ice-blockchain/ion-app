import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class NostrAuth extends IceSimplePage {
  const NostrAuth(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      // Scroll child takes all available screen height to
      // add space around logo (column alignment is space-between)
      // on big devices and be able to scroll on small ones.
      body: SizedBox(
        height: double.infinity,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AuthHeader(
                      title: context.i18n.nostr_auth_title,
                      description: context.i18n.nostr_auth_description,
                      icon: Assets.images.logo.logoIce.icon(size: 65.0.s),
                    ),
                    Assets.images.bg.ostrichlogo.image(
                      width: 256.0.s,
                      height: 160.0.s,
                    ),
                    ScreenSideOffset.large(
                      child: Column(
                        children: <Widget>[
                          Button(
                            leadingIcon:
                                Assets.images.icons.iconLoginCreateacc.icon(),
                            onPressed: () {},
                            type: ButtonType.outlined,
                            label: Text(
                              context.i18n.button_create_account,
                              style: context.theme.appTextThemes.body.copyWith(
                                color: context.theme.appColors.primaryAccent,
                              ),
                            ),
                            mainAxisSize: MainAxisSize.max,
                          ),
                          SizedBox(
                            height: 26.0.s,
                          ),
                          Button(
                            leadingIcon:
                                Assets.images.icons.iconProfileLogin.icon(),
                            onPressed: () {
                              IceRoutes.nostrLogin.push(context);
                            },
                            label: Text(context.i18n.button_login),
                            mainAxisSize: MainAxisSize.max,
                          ),
                          SizedBox(
                            height:
                                58.0.s + MediaQuery.paddingOf(context).bottom,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
