import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_type.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/pages/step_pages.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class AuthenticatorSetupPage extends StatelessWidget {
  const AuthenticatorSetupPage(this.step, {super.key});

  final AuthenticatorSteps step;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: step != AuthenticatorSteps.success,
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              )
            ],
            title:
                step.getAppBarTitle(context) != null ? Text(step.getAppBarTitle(context)!) : null,
          ),
          AuthHeader(
            topOffset: 0.0.s,
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
          if (step.getDescription(context).isNotEmpty) SizedBox(height: 32.0.s),
          Expanded(
            child: switch (step) {
              AuthenticatorSteps.options => AuthenticatorOptionsPage(
                  onTap: (type) {},
                ),
              AuthenticatorSteps.instruction => AuthenticatorInstructionsPage(),
              AuthenticatorSteps.confirmation => AuthenticatorCodeConfirmPage(),
              AuthenticatorSteps.success => AuthenticatorSuccessPage(),
            },
          ),
          SizedBox(height: 12.0.s),
          ScreenSideOffset.large(
            child: Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(
                step.getButtonText(context),
              ),
              onPressed: () => _handleNextStep(context),
            ),
          ),
          ScreenBottomOffset(margin: 36.0.s)
        ],
      ),
    );
  }

  void _handleNextStep(BuildContext context) {
    final nextStep = switch (step) {
      AuthenticatorSteps.options => AuthenticatorSteps.instruction,
      AuthenticatorSteps.instruction => AuthenticatorSteps.confirmation,
      AuthenticatorSteps.confirmation => AuthenticatorSteps.success,
      AuthenticatorSteps.success => null,
    };

    nextStep == null
        ? SecureAccountOptionsRoute().replace(context)
        : AuthenticatorSetupRoute(step: nextStep).push<void>(context);
  }
}
