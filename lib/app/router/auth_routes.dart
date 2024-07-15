part of 'app_routes.dart';

class AuthRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<GetStartedRoute>(path: 'get-started'),
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
