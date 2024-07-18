import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_passkey/sign_up_passkey_form.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SignUpPasskeyPage extends IcePage {
  const SignUpPasskeyPage({super.key});

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
                  title: context.i18n.sign_up_passkey_title,
                  icon: AuthHeaderIcon(
                    icon:
                        Assets.images.icons.iconLoginPasskey.icon(size: 36.0.s),
                  ),
                ),
                ScreenSideOffset.large(
                  child: Column(
                    children: [
                      SizedBox(height: 14.0.s),
                      ListItem(
                        title: Text(
                          context.i18n.sign_up_passkey_advantage_1_title,
                          overflow: TextOverflow.visible,
                        ),
                        subtitle: Text(
                          context.i18n.sign_up_passkey_advantage_1_description,
                          overflow: TextOverflow.visible,
                        ),
                        backgroundColor: context.theme.appColors.attentionRed,
                        leading: Container(
                          width: 48.0.s,
                          height: 68.0.s,
                          decoration: ShapeDecoration(
                            color: context.theme.appColors.tertararyBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0.s),
                                bottomLeft: Radius.circular(12.0.s),
                              ),
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 6.0.s),
                      ),
                      SizedBox(height: 18.0.s),
                      const SignUpPasskeyForm(),
                      SizedBox(height: 12.0.s),
                      Button(
                        type: ButtonType.outlined,
                        onPressed: () async {},
                        label: Text(context.i18n.sign_up_passkey_use_password),
                        mainAxisSize: MainAxisSize.max,
                        borderColor: Colors.transparent,
                        tintColor: context.theme.appColors.primaryAccent,
                      ),
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
