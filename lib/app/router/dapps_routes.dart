// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class DappsRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<DAppsRoute>(path: 'dapps'),
    TypedGoRoute<DAppsListRoute>(path: 'apps-list'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<DAppDetailsRoute>(path: 'dapps-details'),
      ],
    ),
  ];
}

class DAppsRoute extends BaseRouteData {
  DAppsRoute() : super(child: const DAppsPage());
}

class DAppsListRoute extends BaseRouteData {
  DAppsListRoute({required this.$extra}) : super(child: DAppsList(payload: $extra));

  final AppsRouteData $extra;
}

class DAppDetailsRoute extends BaseRouteData {
  DAppDetailsRoute({required this.dappId})
      : super(
          child: DAppDetailsModal(dappId: dappId),
          type: IceRouteType.bottomSheet,
        );
  final int dappId;
}
