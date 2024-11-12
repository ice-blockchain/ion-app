// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class ChatRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<AppTestRoute>(path: 'app-test'),
    TypedGoRoute<ChatSimpleSearchRoute>(path: 'simple-search'),
    TypedGoRoute<ChatAdvancedSearchRoute>(path: 'feed-advanced-search'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<DeleteConversationRoute>(path: 'delete/:conversationId'),
        TypedGoRoute<NewChatModalRoute>(path: 'new-chat'),
        TypedGoRoute<ChatLearnMoreModalRoute>(path: 'learn-more'),
        TypedGoRoute<ShareProfileModalRoute>(path: 'share-profile'),
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

class ChatAdvancedSearchRoute extends BaseRouteData {
  ChatAdvancedSearchRoute({required this.query})
      : super(
          child: ChatAdvancedSearchPage(query: query),
          type: IceRouteType.fade,
        );

  final String query;
}

class NewChatModalRoute extends BaseRouteData {
  NewChatModalRoute()
      : super(
          child: const NewChatModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ChatLearnMoreModalRoute extends BaseRouteData {
  ChatLearnMoreModalRoute()
      : super(
          child: const ChatLearnMoreModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ShareProfileModalRoute extends BaseRouteData {
  ShareProfileModalRoute({required this.title, this.action = ContactRouteAction.pop})
      : super(
          child: ContactsListView(
            appBarTitle: title,
            action: action,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String title;
  final ContactRouteAction action;
}

@TypedGoRoute<PhotoMessagePreviewRoute>(path: '/photo-preview')
class PhotoMessagePreviewRoute extends BaseRouteData {
  PhotoMessagePreviewRoute({
    required this.message,
    required this.senderName,
    required this.sentAt,
    this.photoUrls = const [],
  }) : super(
          child: PhotoMessagePreviewPage(
            photoUrls: photoUrls,
            message: message,
            senderName: senderName,
            sentAt: sentAt,
          ),
          type: IceRouteType.fade,
        );

  final List<String> photoUrls;
  final String message;
  final String senderName;
  final DateTime sentAt;
}
