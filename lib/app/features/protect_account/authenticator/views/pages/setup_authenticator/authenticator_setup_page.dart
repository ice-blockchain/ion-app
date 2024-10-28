// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/sliver_app_bar_with_progress.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/setup_authenticator/step_pages.dart';
import 'package:ion/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class AuthenticatorSetupPage extends HookConsumerWidget {
  const AuthenticatorSetupPage(this.step, {super.key});

  final AuthenticatorSetupSteps step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useState<GlobalKey<FormState>?>(null);

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBarWithProgress(
            progressValue: step == AuthenticatorSetupSteps.success ? null : step.progressValue,
            title: step.getAppBarTitle(context),
            onClose: () => WalletRoute().go(context),
            showBackButton: step != AuthenticatorSetupSteps.success,
            showProgress: step != AuthenticatorSetupSteps.success,
          ),
          SliverFillRemaining(
            hasScrollBody: step == AuthenticatorSetupSteps.options,
            child: Column(
              children: [
                AuthHeader(
                  topOffset: 34.0.s,
                  title: step.getPageTitle(context),
                  description: step.getDescription(context),
                  titleStyle: context.theme.appTextThemes.headline2,
                  descriptionStyle: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                  icon: AuthHeaderIcon(
                    icon: step.headerImageAsset.icon(size: 36.0.s),
                  ),
                ),
                if (step != AuthenticatorSetupSteps.options) SizedBox(height: 32.0.s),
                Expanded(
                  child: switch (step) {
                    AuthenticatorSetupSteps.options => AuthenticatorOptionsPage(onTap: (type) {}),
                    AuthenticatorSetupSteps.instruction => const AuthenticatorInstructionsPage(),
                    AuthenticatorSetupSteps.confirmation => AuthenticatorCodeConfirmPage(
                        onFormKeySet: (key) => formKey.value = key,
                      ),
                    AuthenticatorSetupSteps.success => const AuthenticatorSuccessPage(),
                  },
                ),
                if (step == AuthenticatorSetupSteps.options) const HorizontalSeparator(),
                SizedBox(height: step == AuthenticatorSetupSteps.options ? 12.0.s : 22.0.s),
                ScreenSideOffset.large(
                  child: Button(
                    mainAxisSize: MainAxisSize.max,
                    label: Text(step.getButtonText(context)),
                    onPressed: () => step == AuthenticatorSetupSteps.confirmation
                        ? _validateAndProceed(context, ref, formKey.value, hideKeyboardAndCallOnce)
                        : _navigateToNextStep(context),
                  ),
                ),
                ScreenBottomOffset(margin: 36.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndProceed(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState>? formKey,
    void Function({
      required VoidCallback callback,
    }) hideKeyboardAndCallOnce,
  ) {
    if (formKey?.currentState?.validate() ?? false) {
      hideKeyboardAndCallOnce(
        callback: () {
          ref.read(securityAccountControllerProvider.notifier).toggleAuthenticator(value: true);
          _navigateToNextStep(context);
        },
      );
    }
  }

  void _navigateToNextStep(BuildContext context) {
    final nextStep = switch (step) {
      AuthenticatorSetupSteps.options => AuthenticatorSetupSteps.instruction,
      AuthenticatorSetupSteps.instruction => AuthenticatorSetupSteps.confirmation,
      AuthenticatorSetupSteps.confirmation => AuthenticatorSetupSteps.success,
      AuthenticatorSetupSteps.success => null,
    };

    nextStep == null
        ? SecureAccountOptionsRoute().replace(context)
        : AuthenticatorSetupRoute(step: nextStep).push<void>(context);
  }
}
