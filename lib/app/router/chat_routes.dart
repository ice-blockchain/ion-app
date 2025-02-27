// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class ChatRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<AppTestRoute>(path: 'app-test'),
    TypedGoRoute<ChatSimpleSearchRoute>(path: 'chat-simple-search'),
    TypedGoRoute<ChatAdvancedSearchRoute>(path: 'chat-advanced-search'),
    TypedGoRoute<ArchivedChatsMainRoute>(path: 'archived-chats'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<DeleteConversationRoute>(path: 'delete'),
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

@TypedGoRoute<ConversationRoute>(
  path: '/conversation',
  routes: [
    TypedGoRoute<ChannelDetailRoute>(path: 'channel-detail'),
    TypedGoRoute<EditChannelRoute>(path: 'edit-channel'),
  ],
)
class ConversationRoute extends BaseRouteData {
  ConversationRoute({
    this.conversationId,
    this.receiverPubKey,
  }) : super(
          child: ConversationPage(
            conversationId: conversationId,
            receiverPubKey: receiverPubKey,
          ),
        );

  final String? conversationId;
  final String? receiverPubKey;
}

class ChannelDetailRoute extends BaseRouteData {
  ChannelDetailRoute({required this.uuid})
      : super(
          child: ChannelDetailPage(uuid: uuid),
        );

  final String uuid;
}

class EditChannelRoute extends BaseRouteData {
  EditChannelRoute({required this.uuid})
      : super(
          child: EditChannelPage(uuid: uuid),
        );

  final String uuid;
}

class AppTestRoute extends BaseRouteData {
  AppTestRoute() : super(child: const AppTestPage());
}

class ChatSimpleSearchRoute extends BaseRouteData {
  ChatSimpleSearchRoute({this.query = ''})
      : super(
          child: ChatSimpleSearchPage(query: query),
        );

  final String query;
}

class ChatAdvancedSearchRoute extends BaseRouteData {
  ChatAdvancedSearchRoute({required this.query})
      : super(
          child: ChatAdvancedSearchPage(query: query),
        );

  final String query;
}

class ArchivedChatsMainRoute extends BaseRouteData {
  ArchivedChatsMainRoute()
      : super(
          child: const ArchivedChatsMainPage(),
          type: IceRouteType.slideFromLeft,
        );
}

class DeleteConversationRoute extends BaseRouteData {
  DeleteConversationRoute({required this.conversationIds})
      : super(
          child: DeleteConversationModal(conversationIds: conversationIds),
          type: IceRouteType.bottomSheet,
        );

  final List<String> conversationIds;
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
          child: const CreateChannelModal(),
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
