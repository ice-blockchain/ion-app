// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.gr.dart';

class DappsRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<DAppsRoute>(path: 'dapps'),
    TypedGoRoute<DAppsListRoute>(path: 'apps-list'),
    TypedGoRoute<DAppsSimpleSearchRoute>(path: 'dapps-simple-search'),
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
  DAppsListRoute({
    required this.title,
    this.isSearchVisible = true,
  }) : super(
          child: DAppsList(
            title: title,
            isSearchVisible: isSearchVisible,
          ),
        );

  final String title;
  final bool isSearchVisible;
}

class DAppDetailsRoute extends BaseRouteData {
  DAppDetailsRoute({required this.dappId})
      : super(
          child: DAppDetailsModal(dappId: dappId),
          type: IceRouteType.bottomSheet,
        );
  final int dappId;
}

class DAppsSimpleSearchRoute extends BaseRouteData {
  DAppsSimpleSearchRoute({this.query = ''})
      : super(
          child: DAppsSimpleSearchPage(query: query),
          type: IceRouteType.fade,
        );

  final String query;
}
