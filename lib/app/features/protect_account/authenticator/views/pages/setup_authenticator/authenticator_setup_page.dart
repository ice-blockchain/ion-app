// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/setup_authenticator/step_pages.dart';
import 'package:ion/app/features/protect_account/common/two_fa_utils.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion_identity_client/ion_identity.dart';

class AuthenticatorSetupPage extends HookConsumerWidget {
  const AuthenticatorSetupPage(this.step, {super.key});

  final AuthenticatorSetupSteps step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useState<GlobalKey<FormState>?>(null);
    final codeController = useRef<TextEditingController?>(null);

    return SheetContent(
      body: step == AuthenticatorSetupSteps.success
          ? Padding(
              padding: EdgeInsets.only(top: 45.0.s, bottom: 16.0.s),
              child: const AuthenticatorSuccessPage(),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  primary: false,
                  flexibleSpace: NavigationAppBar.modal(
                    showBackButton: step != AuthenticatorSetupSteps.success,
                    actions: [
                      NavigationCloseButton(
                        onPressed: Navigator.of(context, rootNavigator: true).pop,
                      ),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                  toolbarHeight: NavigationAppBar.modalHeaderHeight,
                  pinned: true,
                ),
                SliverFillRemaining(
                  hasScrollBody: step == AuthenticatorSetupSteps.options,
                  child: Column(
                    children: [
                      AuthHeader(
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
                          AuthenticatorSetupSteps.options =>
                            AuthenticatorOptionsPage(onTap: (type) {}),
                          AuthenticatorSetupSteps.instruction =>
                            const AuthenticatorInstructionsPage(),
                          AuthenticatorSetupSteps.confirmation => AuthenticatorCodeConfirmPage(
                              onFormInitialized: (controller, key) {
                                codeController.value = controller;
                                formKey.value = key;
                              },
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
                              ? _validateAndProceed(
                                  context,
                                  ref,
                                  formKey.value,
                                  codeController.value?.text ?? '',
                                )
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

  Future<void> _validateAndProceed(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState>? formKey,
    String code,
  ) async {
    final isFormValid = formKey?.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }

    await validateTwoFACode(ref, TwoFAType.authenticator(code));
    ref.invalidate(securityAccountControllerProvider);

    if (!context.mounted) {
      return;
    }

    _navigateToNextStep(context);
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
