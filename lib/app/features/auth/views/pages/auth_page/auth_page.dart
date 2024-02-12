import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/providers/ui_auth_provider.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/controllers/email_controller.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/controllers/phone_number_controller.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/widgets/country_code_input.dart';
import 'package:ice/app/features/auth/views/pages/check_email/check_email.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/discover_creators.dart';
import 'package:ice/app/features/auth/views/pages/enter_code/enter_code.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/nostr_auth/nostr_auth.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/select_languages.dart';
import 'package:ice/app/components/auth_header/auth_header.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_fields.dart';
import 'package:ice/app/components/modal_wrapper.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/components/secured_by/secured_by.dart';
import 'package:ice/app/components/socials/socials.dart';
import 'package:ice/app/components/terms_privacy/terms_privacy.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  void showModalScreen(
    Widget screen,
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => ModalWrapper(
        child: screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  Assets.images.fieldEmail.path,
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
                  onTap: () => showModalScreen(
                    const SelectCountries(),
                    context,
                  ),
                ),
                label: context.i18n.auth_signIn_input_phone_number,
                controller: numberController.controller,
                validator: (String? value) => numberController.onVerify(),
                showLeadingSeparator: true,
              ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Button(
                trailingIcon: authState is AuthenticationLoading
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : ImageIcon(
                        AssetImage(Assets.images.buttonNext.path),
                        size: 16,
                      ),
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
              padding: const EdgeInsets.only(top: 14, bottom: 14),
              child: Text(
                context.i18n.auth_signIn_or,
                style: context.theme.appTextThemes.caption
                    .copyWith(color: context.theme.appColors.tertararyText),
              ),
            ),
            Center(
              child: Button(
                type: ButtonType.outlined,
                leadingIcon: ImageIcon(
                  AssetImage(Assets.images.phone.path),
                  size: 24,
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
              padding: const EdgeInsets.only(top: 16, bottom: 22),
              child: Socials(
                onSocialButtonPressed: (SocialButtonType type) {
                  switch (type) {
                    case SocialButtonType.apple:
                      showModalScreen(const CheckEmail(), context);
                    case SocialButtonType.nostr:
                      showModalScreen(const NostrAuth(), context);
                    case SocialButtonType.x:
                      showModalScreen(const FillProfile(), context);
                    case SocialButtonType.fb:
                      showModalScreen(const EnterCode(), context);
                    case SocialButtonType.github:
                      showModalScreen(const SelectLanguages(), context);
                    case SocialButtonType.discord:
                      showModalScreen(const DiscoverCreators(), context);
                    case SocialButtonType.linkedin:
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
            const SecuredBy(),
            const SizedBox(
              height: 20,
            ),
            const TermsPrivacy(),
          ],
        ),
      ),
    );
  }
}
