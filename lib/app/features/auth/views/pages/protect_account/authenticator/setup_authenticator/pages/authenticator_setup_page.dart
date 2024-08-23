import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/progress_bar/app_progress_bar.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_steps.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/setup_authenticator/pages/step_pages.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/providers/protect_account_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class AuthenticatorSetupPage extends HookConsumerWidget {
  const AuthenticatorSetupPage(this.step, {super.key});

  final AuthenticatorSetupSteps step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useState<GlobalKey<FormState>?>(null);

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: step != AuthenticatorSetupSteps.success,
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              ),
            ],
            title:
                step.getAppBarTitle(context) != null ? Text(step.getAppBarTitle(context)!) : null,
          ),
          step == AuthenticatorSetupSteps.success
              ? SizedBox.shrink()
              : AppProgressIndicator(progressValue: step.progressValue),
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
          Expanded(
            child: switch (step) {
              AuthenticatorSetupSteps.options => AuthenticatorOptionsPage(onTap: (type) {}),
              AuthenticatorSetupSteps.instruction => AuthenticatorInstructionsPage(),
              AuthenticatorSetupSteps.confirmation => AuthenticatorCodeConfirmPage(
                  onFormKeySet: (key) => formKey.value = key,
                ),
              AuthenticatorSetupSteps.success => AuthenticatorSuccessPage(),
            },
          ),
          step == AuthenticatorSetupSteps.options ? SizedBox(height: 12.0.s) : SizedBox.shrink(),
          ScreenSideOffset.large(
            child: Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(step.getButtonText(context)),
              onPressed: () => _handleNextStep(context, ref, formKey.value),
            ),
          ),
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }

  void _handleNextStep(BuildContext context, WidgetRef ref, GlobalKey<FormState>? formKey) =>
      step == AuthenticatorSetupSteps.confirmation
          ? _validateAndProceed(context, ref, formKey)
          : _navigateToNextStep(context);

  void _validateAndProceed(BuildContext context, WidgetRef ref, GlobalKey<FormState>? formKey) {
    if (formKey?.currentState?.validate() == true) {
      ref.read(securityContorllerProvider.notifier).toggleAuthenticator(true);
      _navigateToNextStep(context);
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
