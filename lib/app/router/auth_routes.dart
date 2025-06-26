// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.gr.dart';

class AuthRoutes {
  static const authPrefix = 'auth';

  static const onboardingPrefix = 'onboarding';

  static const routes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<GetStartedRoute>(path: '$authPrefix/get-started'),
        TypedGoRoute<SignUpPasskeyRoute>(path: '$authPrefix/sign-up-passkey'),
        TypedGoRoute<SignUpPasswordRoute>(path: '$authPrefix/sign-up-password'),
        TypedGoRoute<RestoreMenuRoute>(path: '$authPrefix/restore-menu'),
        TypedGoRoute<RestoreCredsRoute>(path: '$authPrefix/restore-creds'),
        TypedGoRoute<RecoverUserRoute>(path: '$authPrefix/recover-user'),
        TypedGoRoute<RestoreFromCloudRoute>(path: '$authPrefix/restore-from-cloud'),
        TypedGoRoute<RestoreFromCloudNoKeysRoute>(path: '$authPrefix/restore-from-cloud-no-keys'),
        TypedGoRoute<RecoverUserSuccessRoute>(path: '$authPrefix/recover-user-success'),
        TypedGoRoute<SelectLanguagesRoute>(path: '$onboardingPrefix/select-languages'),
        TypedGoRoute<FillProfileRoute>(path: '$onboardingPrefix/fill-profile'),
        TypedGoRoute<DiscoverCreatorsRoute>(path: '$onboardingPrefix/discover-creators'),
        TypedGoRoute<NotificationsRoute>(path: '$onboardingPrefix/notifications'),
      ],
    ),
  ];
}

class GetStartedRoute extends BaseRouteData {
  GetStartedRoute()
      : super(
          child: const GetStartedPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SignUpPasskeyRoute extends BaseRouteData {
  SignUpPasskeyRoute()
      : super(
          child: const SignUpPasskeyPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SignUpPasswordRoute extends BaseRouteData {
  SignUpPasswordRoute()
      : super(
          child: const SignUpPasswordPage(),
          type: IceRouteType.bottomSheet,
        );
}

class RestoreMenuRoute extends BaseRouteData {
  RestoreMenuRoute()
      : super(
          child: const RestoreMenuPage(),
          type: IceRouteType.bottomSheet,
        );
}

class RestoreCredsRoute extends BaseRouteData {
  RestoreCredsRoute()
      : super(
          child: const RestoreCredsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class RecoverUserSuccessRoute extends BaseRouteData {
  RecoverUserSuccessRoute()
      : super(
          child: const RecoverUserSuccessPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SelectLanguagesRoute extends BaseRouteData {
  SelectLanguagesRoute()
      : super(
          child: const SelectLanguages(),
          type: IceRouteType.bottomSheet,
        );
}

class FillProfileRoute extends BaseRouteData {
  FillProfileRoute()
      : super(
          child: const FillProfile(),
          type: IceRouteType.bottomSheet,
        );
}

class DiscoverCreatorsRoute extends BaseRouteData {
  DiscoverCreatorsRoute()
      : super(
          child: const DiscoverCreators(),
          type: IceRouteType.bottomSheet,
        );
}

class NotificationsRoute extends BaseRouteData {
  NotificationsRoute()
      : super(
          child: const TurnOnNotifications(),
          type: IceRouteType.bottomSheet,
        );
}

class RecoverUserRoute extends BaseRouteData {
  RecoverUserRoute()
      : super(
          child: const RecoverUserPage(),
          type: IceRouteType.bottomSheet,
        );
}

class RestoreFromCloudRoute extends BaseRouteData {
  RestoreFromCloudRoute()
      : super(
          child: const RestoreFromCloudPage(),
          type: IceRouteType.bottomSheet,
        );
}

class RestoreFromCloudNoKeysRoute extends BaseRouteData {
  RestoreFromCloudNoKeysRoute()
      : super(
          child: const RestoreFromCloudNoKeysAvailableModal(),
          type: IceRouteType.bottomSheet,
        );
}
