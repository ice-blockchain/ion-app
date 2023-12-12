import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/pages/check_email/check_email.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/app/shared/widgets/email_input.dart';
import 'package:ice/app/shared/widgets/modal_wrapper.dart';
import 'package:ice/app/shared/widgets/secured_by/secured_by.dart';
import 'package:ice/app/shared/widgets/socials/socials.dart';
import 'package:ice/app/shared/widgets/terms_privacy/terms_privacy.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  void showCheckEmail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const ModalWrapper(
        child: CheckEmail(),
      ),
    );
  }

  void showSelectCountries(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const ModalWrapper(
        child: SelectCountries(),
      ),
    );
  }

  void showFillProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const ModalWrapper(
        child: FillProfile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 65,
            ),
            Image.asset(
              Assets.images.iceRound.path,
            ),
            const SizedBox(
              height: 19,
            ),
            Text(
              'Get started',
              style: context.theme.appTextThemes.headline1,
            ),
            Text(
              'Choose your login method',
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.tertararyText,
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            EmailInput(formKey: emailFormKey),
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
                  // showCheckEmail(context);
                  // showSelectCountries(context);
                  showFillProfile(context);
                },
                label: const Text('Continue with Phone'),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 22),
              child: Socials(),
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
