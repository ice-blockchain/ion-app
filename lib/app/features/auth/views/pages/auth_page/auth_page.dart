import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_fields.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/sheet_content/sheet_content.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/providers/ui_auth_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/secured_by/secured_by.dart';
import 'package:ice/app/features/auth/views/components/socials/socials.dart';
import 'package:ice/app/features/auth/views/components/terms_privacy/terms_privacy.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/country_code_input.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/controllers/email_controller.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/controllers/phone_number_controller.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthPage extends IceSimplePage {
  const AuthPage(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final AuthState authState = ref.watch(authProvider);
    final bool isEmailMode = ref.watch(isEmailModeProvider);
    final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

    final EmailController emailController = EmailController();
    final PhoneNumberController numberController = PhoneNumberController();

    return SheetContent(
      body: ScreenSideOffset.large(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 2.0.s),
              child: AuthHeaderWidget(
                title: context.i18n.auth_signIn_title,
                description: context.i18n.auth_signIn_description,
              ),
            ),
            if (isEmailMode)
              InputField(
                leadingIcon: Assets.images.icons.iconFieldEmail.icon(
                  color: context.theme.appColors.primaryText,
                  size: 24.0.s,
                ),
                label: context.i18n.auth_signIn_input_email,
                controller: emailController.controller,
                validator: (String? value) => emailController.onVerify(),
                showLeadingSeparator: true,
              ),
            if (!isEmailMode)
              InputField(
                leadingIcon: CountryCodeInput(
                  country: countries[1],
                  onTap: () => IceRoutes.selectCountries.push(context),
                ),
                label: context.i18n.auth_signIn_input_phone_number,
                controller: numberController.controller,
                validator: (String? value) => numberController.onVerify(),
                showLeadingSeparator: true,
              ),
            Center(
              child: Button(
                trailingIcon: authState is AuthenticationLoading
                    ? const ButtonLoadingIndicator()
                    : Assets.images.icons.iconButtonNext
                        .icon(color: context.theme.appColors.onPrimaryAccent),
                onPressed: () => <void>{
                  emailFormKey.currentState?.reset(),
                  ref
                      .read(authProvider.notifier)
                      .signIn(email: 'foo@bar.baz', password: '123'),
                },
                label: Text(context.i18n.button_continue),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.0.s, bottom: 14.0.s),
              child: Text(
                context.i18n.auth_signIn_or,
                style: context.theme.appTextThemes.caption
                    .copyWith(color: context.theme.appColors.tertararyText),
              ),
            ),
            Center(
              child: Button(
                type: ButtonType.outlined,
                leadingIcon: Assets.images.icons.iconFieldPhone.icon(
                  color: context.theme.appColors.secondaryText,
                ),
                onPressed: () {
                  ref.read(isEmailModeProvider.notifier).state = !isEmailMode;
                },
                label: Text(
                  isEmailMode
                      ? context.i18n.auth_signIn_button_phone_number
                      : context.i18n.auth_signIn_button_email,
                ),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0.s, bottom: 72.0.s),
              child: Socials(
                onSocialButtonPressed: (SocialButtonType type) {
                  switch (type) {
                    case SocialButtonType.apple:
                      IceRoutes.checkEmail.push(context);
                    case SocialButtonType.nostr:
                      IceRoutes.nostrAuth.push(context);
                    case SocialButtonType.x:
                      IceRoutes.fillProfile.push(context);
                    case SocialButtonType.fb:
                      IceRoutes.enterCode.push(context);
                    case SocialButtonType.github:
                      IceRoutes.selectLanguages.push(context);
                    case SocialButtonType.discord:
                      IceRoutes.discoverCreators.push(context);
                    case SocialButtonType.linkedin:
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
            const SecuredBy(),
            SizedBox(
              height: 14.0.s,
            ),
            const TermsPrivacy(),
          ],
        ),
      ),
    );
  }
}
