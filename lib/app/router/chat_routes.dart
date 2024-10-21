// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class ChatRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<AppTestRoute>(path: 'app-test'),
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
