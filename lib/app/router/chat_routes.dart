// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class ChatRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<AppTestRoute>(path: 'app-test'),
    TypedGoRoute<ChatSimpleSearchRoute>(path: 'simple-search'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<DeleteConversationRoute>(path: 'delete/:conversationId'),
      ],
    ),
  ];
}

class AppTestRoute extends BaseRouteData {
  AppTestRoute() : super(child: const AppTestPage());
}

class DeleteConversationRoute extends BaseRouteData {
  DeleteConversationRoute({required this.conversationId})
      : super(
          child: DeleteConversationModal(conversationId: conversationId),
          type: IceRouteType.bottomSheet,
        );

  final String conversationId;
}

class ChatSimpleSearchRoute extends BaseRouteData {
  ChatSimpleSearchRoute({this.query = ''})
      : super(
          child: ChatSimpleSearchPage(query: query),
          type: IceRouteType.fade,
        );

  final String query;
}
