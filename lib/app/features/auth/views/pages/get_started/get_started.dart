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
import 'package:ice/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/get_started/login_form.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class GetStartedPage extends IcePage {
  const GetStartedPage({super.key});

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
                  title: context.i18n.get_started_title,
                  description: context.i18n.get_started_description,
                  icon: Assets.images.logo.logoIce.icon(size: 65.0.s),
                  showBackButton: false,
                ),
                ScreenSideOffset.large(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 56.0.s),
                      const LoginForm(),
                      SizedBox(height: 14.0.s),
                      Text(
                        context.i18n.get_started_method_divider,
                        style: context.theme.appTextThemes.caption.copyWith(
                          color: context.theme.appColors.tertararyText,
                        ),
                      ),
                      SizedBox(height: 14.0.s),
                      Button(
                        type: ButtonType.outlined,
                        leadingIcon:
                            Assets.images.icons.iconLoginCreateacc.icon(
                          color: context.theme.appColors.secondaryText,
                        ),
                        onPressed: () {},
                        label: Text(context.i18n.button_register),
                        mainAxisSize: MainAxisSize.max,
                      ),
                      SizedBox(height: 16.0.s),
                      Button(
                        type: ButtonType.outlined,
                        leadingIcon: Assets.images.icons.iconRestorekey.icon(
                          color: context.theme.appColors.secondaryText,
                        ),
                        onPressed: () async {},
                        label: Text(context.i18n.get_started_restore_button),
                        mainAxisSize: MainAxisSize.max,
                        borderColor: Colors.transparent,
                      ),
                      SizedBox(height: 27.0.s),
                    ],
                  ),
                ),
                const AuthFooter(),
                ScreenBottomOffset(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
