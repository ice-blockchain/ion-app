import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/components/sign_up_list_item/sign_up_list_item.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_passkey/sign_up_passkey_form.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_password/sign_up_password_form.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SignUpPasswordPage extends IcePage {
  const SignUpPasswordPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: KeyboardDismissOnTap(
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthHeader(
                  title: context.i18n.sign_up_password_title,
                  description: context.i18n.sign_up_password_description,
                  icon: AuthHeaderIcon(
                    icon: Assets.images.icons.iconLoginPassword
                        .icon(size: 36.0.s),
                  ),
                ),
                ScreenSideOffset.large(
                  child: Column(
                    children: [
                      SizedBox(height: 32.0.s),
                      SignUpListItem(
                        title:
                            context.i18n.sign_up_password_disadvantage_1_title,
                        subtitle: context
                            .i18n.sign_up_password_disadvantage_1_description,
                        icon: Assets.images.icons.iconLoginHack.icon(),
                      ),
                      SignUpListItem(
                        title:
                            context.i18n.sign_up_password_disadvantage_2_title,
                        subtitle: context
                            .i18n.sign_up_password_disadvantage_2_description,
                        icon: Assets.images.icons.iconLoginReused.icon(),
                      ),
                      SignUpListItem(
                        title:
                            context.i18n.sign_up_password_disadvantage_3_title,
                        subtitle: context
                            .i18n.sign_up_password_disadvantage_3_description,
                        icon: Assets.images.icons.iconLoginManage.icon(),
                      ),
                      SizedBox(height: 18.0.s),
                      const SignUpPasswordForm(),
                    ],
                  ),
                ),
                ScreenBottomOffset(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
