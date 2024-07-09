part of 'app_routes.dart';

class AuthRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<AuthRoute>(path: 'auth'),
        TypedGoRoute<SelectCountriesRoute>(path: 'select-countries'),
        TypedGoRoute<SelectLanguagesRoute>(path: 'select-languages'),
        TypedGoRoute<CheckEmailRoute>(path: 'check-email'),
        TypedGoRoute<FillProfileRoute>(path: 'fill-profile'),
        TypedGoRoute<DiscoverCreatorsRoute>(path: 'discover-creators'),
        TypedGoRoute<NostrAuthRoute>(path: 'nostr-auth'),
        TypedGoRoute<NostrLoginRoute>(path: 'nostr-login'),
        TypedGoRoute<EnterCodeRoute>(path: 'enter-code'),
        TypedGoRoute<NotificationsRoute>(path: 'notifications'),
      ],
    ),
  ];
}

class AuthRoute extends BaseRouteData {
  AuthRoute()
      : super(
          child: const AuthPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SelectCountriesRoute extends BaseRouteData {
  SelectCountriesRoute()
      : super(
          child: const SelectCountries(),
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

class CheckEmailRoute extends BaseRouteData {
  CheckEmailRoute()
      : super(
          child: const CheckEmail(),
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

class NostrAuthRoute extends BaseRouteData {
  NostrAuthRoute()
      : super(
          child: const NostrAuth(),
          type: IceRouteType.bottomSheet,
        );
}

class NostrLoginRoute extends BaseRouteData {
  NostrLoginRoute()
      : super(
          child: const NostrLogin(),
          type: IceRouteType.bottomSheet,
        );
}

class EnterCodeRoute extends BaseRouteData {
  EnterCodeRoute()
      : super(
          child: const EnterCode(),
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
