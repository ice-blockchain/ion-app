import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/providers/ui_auth_provider.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/controllers/email_controller.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/controllers/phone_number_controller.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/widgets/country_code_input.dart';
import 'package:ice/app/features/auth/views/pages/check_email/check_email.dart';
import 'package:ice/app/features/auth/views/pages/enter_code/enter_code.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/nostr_auth/nostr_auth.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country.dart';
import 'package:ice/app/shared/widgets/auth_header/auth_header.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/app/shared/widgets/inputs/text_fields.dart';
import 'package:ice/app/shared/widgets/modal_wrapper.dart';
import 'package:ice/app/shared/widgets/secured_by/secured_by.dart';
import 'package:ice/app/shared/widgets/socials/socials.dart';
import 'package:ice/app/shared/widgets/terms_privacy/terms_privacy.dart';
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: <Widget>[
            AuthHeaderWidget(
              title: 'Get started',
              description: 'Choose your login method',
            ),
            // EmailInput(formKey: emailFormKey),
            if (isEmailMode)
              InputField(
                leadingIcon: Image.asset(
                  Assets.images.fieldEmail.path,
                  color: context.theme.appColors.primaryText,
                ),
                label: 'Email address',
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
                label: 'Phone number',
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
                label: const Text('Continue'),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 14),
              child: Text(
                'or',
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
                  isEmailMode ? 'Continue with Email' : 'Continue with Phone',
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
                      break;
                    case SocialButtonType.discord:
                      break;
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
