import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/components/authenticator_progress_bar.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_type.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/pages/step_pages.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class AuthenticatorSetupPage extends HookWidget {
  const AuthenticatorSetupPage(this.step, {super.key});

  final AuthenticatorSteps step;

  @override
  Widget build(BuildContext context) {
    final formKey = useState<GlobalKey<FormState>?>(null);

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: step != AuthenticatorSteps.success,
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              ),
            ],
            title:
                step.getAppBarTitle(context) != null ? Text(step.getAppBarTitle(context)!) : null,
          ),
          AuthenticatorProgressBar(currentStep: step),
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
              AuthenticatorSteps.options => AuthenticatorOptionsPage(onTap: (type) {}),
              AuthenticatorSteps.instruction => AuthenticatorInstructionsPage(),
              AuthenticatorSteps.confirmation => AuthenticatorCodeConfirmPage(
                  onFormKeySet: (key) => formKey.value = key,
                ),
              AuthenticatorSteps.success => AuthenticatorSuccessPage(),
            },
          ),
          ScreenSideOffset.large(
            child: Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(step.getButtonText(context)),
              onPressed: () => _handleNextStep(context, formKey.value),
            ),
          ),
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }

  void _handleNextStep(BuildContext context, GlobalKey<FormState>? formKey) =>
      step == AuthenticatorSteps.confirmation
          ? _validateAndProceed(context, formKey)
          : _navigateToNextStep(context);

  void _validateAndProceed(BuildContext context, GlobalKey<FormState>? formKey) {
    if (formKey?.currentState?.validate() == true) {
      _navigateToNextStep(context);
    }
  }

  void _navigateToNextStep(BuildContext context) {
    final nextStep = switch (step) {
      AuthenticatorSteps.options => AuthenticatorSteps.instruction,
      AuthenticatorSteps.instruction => AuthenticatorSteps.confirmation,
      AuthenticatorSteps.confirmation => AuthenticatorSteps.success,
      AuthenticatorSteps.success => null,
    };

    if (nextStep == null) {
      SecureAccountOptionsRoute().replace(context);
    } else {
      AuthenticatorSetupRoute(step: nextStep).push<void>(context);
    }
  }
}
