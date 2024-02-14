import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_fields.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
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
import 'package:ice/app/shared/widgets/template/ice_page.dart';
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

    return Scaffold(
      body: ScreenSideOffset.large(
        child: Column(
          children: <Widget>[
            AuthHeaderWidget(
              title: context.i18n.auth_signIn_title,
              description: context.i18n.auth_signIn_description,
            ),
            if (isEmailMode)
              InputField(
                leadingIcon: Image.asset(
                  Assets.images.icons.iconFieldEmail.path,
                  color: context.theme.appColors.primaryText,
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
                  onTap: () => context.goNamed(IceRoutes.selectCountries.name),
                ),
                label: context.i18n.auth_signIn_input_phone_number,
                controller: numberController.controller,
                validator: (String? value) => numberController.onVerify(),
                showLeadingSeparator: true,
              ),
            SizedBox(
              height: 16.0.s,
            ),
            Center(
              child: Button(
                trailingIcon: authState is AuthenticationLoading
                    ? const ButtonLoadingIndicator()
                    : ButtonIcon(Assets.images.icons.iconButtonNext.path),
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
                leadingIcon: ButtonIcon(
                  Assets.images.icons.iconFieldPhone.path,
                  color: context.theme.appColors.secondaryText,
                ),
                onPressed: () {
                  ref.read(isEmailModeProvider.notifier).state = !isEmailMode;
                },
                label: Text(
                  isEmailMode
                      ? context.i18n.auth_signIn_button_email
                      : context.i18n.auth_signIn_button_phone_number,
                ),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0.s, bottom: 22.0.s),
              child: Socials(
                onSocialButtonPressed: (SocialButtonType type) {
                  switch (type) {
                    case SocialButtonType.apple:
                      context.goNamed(IceRoutes.checkEmail.name);
                    case SocialButtonType.nostr:
                      context.goNamed(IceRoutes.nostrAuth.name);
                    case SocialButtonType.x:
                      context.goNamed(IceRoutes.fillProfile.name);
                    case SocialButtonType.fb:
                      context.goNamed(IceRoutes.enterCode.name);
                    case SocialButtonType.github:
                      context.goNamed(IceRoutes.selectLanguages.name);
                    case SocialButtonType.discord:
                      context.goNamed(IceRoutes.discoverCreators.name);
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
              height: 20.0.s,
            ),
            const TermsPrivacy(),
          ],
        ),
      ),
    );
  }
}
