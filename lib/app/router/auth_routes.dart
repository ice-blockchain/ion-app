part of 'app_routes.dart';

class AuthRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<GetStartedRoute>(path: 'get-started'),
        TypedGoRoute<SignUpPasskeyRoute>(path: 'sign-up-passkey'),
        TypedGoRoute<SignUpPasswordRoute>(path: 'sign-up-password'),
        TypedGoRoute<RestoreMenuRoute>(path: 'restore-menu'),
        TypedGoRoute<RestoreCredsRoute>(path: 'restore-creds'),
        TypedGoRoute<RestoreRecoveryKeysRoute>(path: 'recovery-keys'),
        TypedGoRoute<TwoFaCodesRoute>(path: 'twofa-codes'),
        TypedGoRoute<TwoFaOptionsRoute>(path: 'twofa-options'),
        TypedGoRoute<TwoFaSuccessRoute>(path: 'twofa-success'),
        TypedGoRoute<SelectLanguagesRoute>(path: 'select-languages'),
        TypedGoRoute<FillProfileRoute>(path: 'fill-profile'),
        TypedGoRoute<DiscoverCreatorsRoute>(path: 'discover-creators'),
        TypedGoRoute<NotificationsRoute>(path: 'notifications'),
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

class TwoFaCodesRoute extends BaseRouteData {
  TwoFaCodesRoute({required this.$extra})
      : super(
          child: TwoFaCodesPage(twoFaTypes: $extra),
          type: IceRouteType.bottomSheet,
        );
  final Set<TwoFaType> $extra;
}

class TwoFaOptionsRoute extends BaseRouteData {
  TwoFaOptionsRoute()
      : super(
          child: const TwoFaOptionsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class TwoFaSuccessRoute extends BaseRouteData {
  TwoFaSuccessRoute()
      : super(
          child: const TwoFaSuccessPage(),
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

class RestoreRecoveryKeysRoute extends BaseRouteData {
  RestoreRecoveryKeysRoute()
      : super(
          child: const RestoreRecoveryKeysPage(),
          type: IceRouteType.bottomSheet,
        );
}
