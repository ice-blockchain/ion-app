import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_type.dart';

class AuthenticatorProgressBar extends StatelessWidget {
  final AuthenticatorSteps currentStep;

  const AuthenticatorProgressBar({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStep == AuthenticatorSteps.success) {
      return SizedBox.shrink();
    }

    return Container(
      height: 3.0.s,
      child: LinearProgressIndicator(
        value: _getProgressValue(),
        backgroundColor: context.theme.appColors.secondaryBackground,
        valueColor: AlwaysStoppedAnimation<Color>(context.theme.appColors.primaryAccent),
      ),
    );
  }

  double _getProgressValue() => switch (currentStep) {
        AuthenticatorSteps.options => 0.25,
        AuthenticatorSteps.instruction => 0.7,
        AuthenticatorSteps.confirmation => 0.9,
        AuthenticatorSteps.success => 1.0
      };
}
