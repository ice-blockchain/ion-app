// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class ProtectAccountRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<SecureAccountModalRoute>(path: '/secure-account-modal'),
    TypedGoRoute<SecureAccountOptionsRoute>(path: '/secure-account-options'),
    TypedGoRoute<SecureAccountErrorRoute>(path: '/secure-account-error'),
    TypedGoRoute<BackupOptionsRoute>(path: '/backup-options'),
    TypedGoRoute<BackupRecoveryKeysRoute>(path: '/backup-recovery-keys'),
    TypedGoRoute<CreateRecoveryKeyRoute>(path: '/recovery-keys-save'),
    TypedGoRoute<ValidateRecoveryKeyRoute>(path: '/recovery-keys-input'),
    TypedGoRoute<RecoveryKeysSuccessRoute>(path: '/recovery-keys-success'),
    TypedGoRoute<ScreenshotSecurityAlertRoute>(path: '/screenshot-security-alert'),
    TypedGoRoute<RecoveryKeysErrorAlertRoute>(path: '/recovery-keys-error-alert'),
    TypedGoRoute<AuthenticatorSetupRoute>(path: '/authenticator-setup/:step'),
    TypedGoRoute<AuthenticatorDeleteRoute>(path: '/authenticator-delete'),
    TypedGoRoute<AuthenticatorDeleteSuccessRoute>(path: '/authenticator-delete-success'),
    TypedGoRoute<EmailSetupRoute>(path: '/email-setup/:step'),
    TypedGoRoute<EmailDeleteRoute>(path: '/email-delete'),
    TypedGoRoute<EmailDeleteSuccessRoute>(path: '/email-delete-success'),
    TypedGoRoute<PhoneSetupRoute>(path: '/phone-setup/:step'),
    TypedGoRoute<PhoneDeleteRoute>(path: '/phone-delete'),
    TypedGoRoute<PhoneDeleteSuccessRoute>(path: '/phone-delete-success'),
    TypedGoRoute<SelectCountriesRoute>(path: '/select-countries'),
  ];
}

class SecureAccountModalRoute extends BaseRouteData {
  SecureAccountModalRoute()
      : super(
          child: const SecureAccountModal(),
          type: IceRouteType.bottomSheet,
        );
}

class SecureAccountOptionsRoute extends BaseRouteData {
  SecureAccountOptionsRoute()
      : super(
          child: const SecureAccountOptionsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SecureAccountErrorRoute extends BaseRouteData {
  SecureAccountErrorRoute()
      : super(
          child: const SecureAccountErrorAlert(),
          type: IceRouteType.bottomSheet,
        );
}

class BackupOptionsRoute extends BaseRouteData {
  BackupOptionsRoute()
      : super(
          child: const BackupOptionsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class BackupRecoveryKeysRoute extends BaseRouteData {
  BackupRecoveryKeysRoute()
      : super(
          child: const BackupRecoveryKeysModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CreateRecoveryKeyRoute extends BaseRouteData {
  CreateRecoveryKeyRoute()
      : super(
          child: const CreateRecoveryKeyPage(),
          type: IceRouteType.bottomSheet,
        );
}

class ValidateRecoveryKeyRoute extends BaseRouteData {
  ValidateRecoveryKeyRoute()
      : super(
          child: const ValidateRecoveryKeyPage(),
          type: IceRouteType.bottomSheet,
        );
}

class RecoveryKeysSuccessRoute extends BaseRouteData {
  RecoveryKeysSuccessRoute()
      : super(
          child: const RecoveryKeysSuccessPage(),
          type: IceRouteType.bottomSheet,
        );
}

class ScreenshotSecurityAlertRoute extends BaseRouteData {
  ScreenshotSecurityAlertRoute()
      : super(
          child: const ScreenshotSecurityAlert(),
          type: IceRouteType.bottomSheet,
        );
}

class RecoveryKeysErrorAlertRoute extends BaseRouteData {
  RecoveryKeysErrorAlertRoute()
      : super(
          child: const RecoveryKeysErrorAlert(),
          type: IceRouteType.bottomSheet,
        );
}

class AuthenticatorSetupRoute extends BaseRouteData {
  AuthenticatorSetupRoute({required this.step})
      : super(
          child: AuthenticatorSetupPage(step),
          type: IceRouteType.bottomSheet,
        );

  final AuthenticatorSetupSteps step;
}

class AuthenticatorDeleteRoute extends BaseRouteData {
  AuthenticatorDeleteRoute()
      : super(
          child: const AuthenticatorDeletePage(),
          type: IceRouteType.bottomSheet,
        );
}

class AuthenticatorDeleteSuccessRoute extends BaseRouteData {
  AuthenticatorDeleteSuccessRoute()
      : super(
          child: const AuthenticatorDeleteSuccessPage(),
          type: IceRouteType.bottomSheet,
        );
}

class EmailSetupRoute extends BaseRouteData {
  EmailSetupRoute({required this.step, this.email})
      : super(
          child: EmailSetupPage(step, email),
          type: IceRouteType.bottomSheet,
        );

  final EmailSetupSteps step;
  String? email;
}

class EmailDeleteRoute extends BaseRouteData {
  EmailDeleteRoute()
      : super(
          child: const EmailDeletePage(),
          type: IceRouteType.bottomSheet,
        );
}

class EmailDeleteSuccessRoute extends BaseRouteData {
  EmailDeleteSuccessRoute()
      : super(
          child: const EmailDeleteSuccessPage(),
          type: IceRouteType.bottomSheet,
        );
}

class PhoneSetupRoute extends BaseRouteData {
  PhoneSetupRoute({required this.step, this.phone})
      : super(
          child: PhoneSetupPage(step, phone),
          type: IceRouteType.bottomSheet,
        );

  final PhoneSetupSteps step;
  String? phone;
}

class PhoneDeleteRoute extends BaseRouteData {
  PhoneDeleteRoute()
      : super(
          child: const PhoneDeletePage(),
          type: IceRouteType.bottomSheet,
        );
}

class PhoneDeleteSuccessRoute extends BaseRouteData {
  PhoneDeleteSuccessRoute()
      : super(
          child: const PhoneDeleteSuccessPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SelectCountriesRoute extends BaseRouteData {
  SelectCountriesRoute()
      : super(
          child: const SelectCountryPage(),
          type: IceRouteType.bottomSheet,
        );
}
