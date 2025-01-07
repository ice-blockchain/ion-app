// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class ChatRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<AppTestRoute>(path: 'app-test'),
    TypedGoRoute<ChatSimpleSearchRoute>(path: 'simple-search'),
    TypedGoRoute<ChatAdvancedSearchRoute>(path: 'feed-advanced-search'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<DeleteConversationRoute>(path: 'delete/:conversationId'),
        TypedGoRoute<NewChatModalRoute>(path: 'new-chat'),
        TypedGoRoute<NewChannelModalRoute>(path: 'new-channel'),
        TypedGoRoute<ChatLearnMoreModalRoute>(path: 'learn-more'),
        TypedGoRoute<ShareProfileModalRoute>(path: 'share-profile'),
        TypedGoRoute<ChatAddPollModalRoute>(path: 'add-poll'),
        TypedGoRoute<SearchEmojiRoute>(path: 'search-emoji'),
        TypedGoRoute<AddParticipantsToGroupModalRoute>(path: 'add-participants-to-group'),
        TypedGoRoute<CreateGroupModalRoute>(path: 'create-group'),
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

class NewChannelModalRoute extends BaseRouteData {
  NewChannelModalRoute()
      : super(
          child: const NewChannelModal(),
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
  ShareProfileModalRoute()
      : super(
          child: const ShareProfileModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ChatAddPollModalRoute extends BaseRouteData {
  ChatAddPollModalRoute()
      : super(
          child: const ChatAddPollModal(),
          type: IceRouteType.bottomSheet,
        );
}

class AddParticipantsToGroupModalRoute extends BaseRouteData {
  AddParticipantsToGroupModalRoute()
      : super(
          child: const AddGroupParticipantsModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CreateGroupModalRoute extends BaseRouteData {
  CreateGroupModalRoute()
      : super(
          child: const CreateGroupModal(),
          type: IceRouteType.bottomSheet,
        );
}

@TypedGoRoute<GroupRoute>(path: '/group/:pubkey')
class GroupRoute extends BaseRouteData {
  GroupRoute({required this.pubkey})
      : super(
          child: GroupPage(pubkey: pubkey),
        );

  final String pubkey;
}
