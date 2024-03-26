import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/terms_privacy/terms_privacy.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/email_auth_form.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/phone_auth_form.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/secured_by.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/socials.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthPage extends IceSimplePage {
  const AuthPage(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<bool> isEmailMode = useState(true);

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: ScreenSideOffset.large(
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AuthHeaderWidget(
                  title: context.i18n.auth_signIn_title,
                  description: context.i18n.auth_signIn_description,
                ),
                SizedBox(
                  height: 30.0.s,
                ),
                if (isEmailMode.value) EmailAuthForm() else PhoneAuthForm(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0.s),
                  child: Text(
                    context.i18n.auth_signIn_or,
                    style: context.theme.appTextThemes.caption.copyWith(
                      color: context.theme.appColors.tertararyText,
                    ),
                  ),
                ),
                Button(
                  type: ButtonType.outlined,
                  leadingIcon: Assets.images.icons.iconFieldPhone.icon(
                    color: context.theme.appColors.secondaryText,
                  ),
                  onPressed: () {
                    isEmailMode.value = !isEmailMode.value;
                  },
                  label: Text(
                    isEmailMode.value
                        ? context.i18n.auth_signIn_button_phone_number
                        : context.i18n.auth_signIn_button_email,
                  ),
                  mainAxisSize: MainAxisSize.max,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0.s, bottom: 22.0.s),
                  child: const Socials(),
                ),
                const SecuredBy(),
                SizedBox(height: 14.0.s),
                const TermsPrivacy(),
                SizedBox(
                  height: 14.0.s + MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
