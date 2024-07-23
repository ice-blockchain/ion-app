import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_scrolled_body.dart';
import 'package:ice/app/features/auth/views/pages/restore_menu/restore_menu_item.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RestoreMenuPage extends StatelessWidget {
  const RestoreMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: SizedBox(
        height: double.infinity,
        child: AuthScrollContainer(
          title: context.i18n.restore_identity_title,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AuthHeader(
                    title: context.i18n.restore_identity_title,
                    description: context.i18n.restore_identity_type_description,
                    icon: AuthHeaderIcon(
                      icon: Assets.images.icons.iconLoginRestorekey.icon(size: 36.0.s),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 38.0.s),
                    child: Column(
                      children: [
                        SizedBox(height: 12.0.s),
                        RestoreMenuItem(
                          icon: Assets.images.identity.walletLoginCloud.icon(size: 48.0.s),
                          title: context.i18n.restore_identity_type_icloud_title,
                          description: context.i18n.restore_identity_type_icloud_description,
                          onPressed: () {},
                        ),
                        SizedBox(height: 16.0.s),
                        RestoreMenuItem(
                          icon: Assets.images.identity.walletLoginRecovery.icon(size: 48.0.s),
                          title: context.i18n.restore_identity_type_credentials_title,
                          description: context.i18n.restore_identity_type_credentials_description,
                          onPressed: () {},
                        ),
                        SizedBox(height: 12.0.s),
                      ],
                    ),
                  ),
                  ScreenBottomOffset(
                    child: const AuthFooter(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
