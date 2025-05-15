// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class ChatRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<AppTestRoute>(path: 'app-test'),
    TypedGoRoute<ChatQuickSearchRoute>(path: 'chat-simple-search'),
    TypedGoRoute<ChatAdvancedSearchRoute>(path: 'chat-advanced-search'),
    TypedGoRoute<ArchivedChatsMainRoute>(path: 'archived-chats'),
    TypedGoRoute<ConversationRoute>(
      path: 'conversation-fullstack',
      routes: [
        TypedGoRoute<ChannelDetailRoute>(path: 'channel-detail'),
        TypedGoRoute<EditChannelRoute>(path: 'edit-channel'),
      ],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<DeleteConversationRoute>(path: 'delete-conversation'),
        TypedGoRoute<DeleteMessageRoute>(path: 'delete-message'),
        TypedGoRoute<NewChatModalRoute>(path: 'new-chat'),
        TypedGoRoute<NewChannelModalRoute>(path: 'new-channel'),
        TypedGoRoute<ChatLearnMoreModalRoute>(path: 'learn-more'),
        TypedGoRoute<SendProfileModalRoute>(path: 'send-profile'),
        TypedGoRoute<ChatAddPollModalRoute>(path: 'add-poll'),
        TypedGoRoute<SearchEmojiRoute>(path: 'search-emoji'),
        TypedGoRoute<AddParticipantsToGroupModalRoute>(path: 'add-participants-to-group'),
        TypedGoRoute<CreateGroupModalRoute>(path: 'create-group'),
        TypedGoRoute<ShareViaMessageModalRoute>(path: 'share-via-message/:eventReference'),
        TypedGoRoute<PaymentSelectionChatRoute>(path: 'select-payment-type'),
        TypedGoRoute<SelectCoinChatRoute>(path: 'coin-selector-chat'),
        TypedGoRoute<SelectNetworkChatRoute>(path: 'network-selector-chat'),
        TypedGoRoute<SendCoinsFormChatRoute>(path: 'send-coins-form-chat'),
        TypedGoRoute<SelectContactChatRoute>(path: 'select-contact-chat'),
        TypedGoRoute<CoinSendScanChatRoute>(path: 'scan-receiver-wallet-chat'),
        TypedGoRoute<SendCoinsConfirmationChatRoute>(path: 'send-form-confirmation-chat'),
        TypedGoRoute<CoinTransactionResultChatRoute>(path: 'coin-transaction-result-chat'),
        TypedGoRoute<CoinTransactionDetailsChatRoute>(path: 'coin-transaction-details-chat'),
        TypedGoRoute<ExploreTransactionDetailsChatRoute>(path: 'coin-transaction-explore-chat'),
        TypedGoRoute<RequestCoinsFormChatRoute>(path: 'request-coins-form-chat'),
        TypedGoRoute<AddressNotFoundChatRoute>(path: 'address-not-found'),
      ],
    ),
  ];
}

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

class ChatQuickSearchRoute extends BaseRouteData {
  ChatQuickSearchRoute({this.query = ''})
      : super(
          child: ChatQuickSearchPage(query: query),
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

class DeleteMessageRoute extends BaseRouteData {
  DeleteMessageRoute({required this.isMe})
      : super(
          child: DeleteMessageModal(isMe: isMe),
          type: IceRouteType.bottomSheet,
        );

  final bool isMe;
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

class SendProfileModalRoute extends BaseRouteData {
  SendProfileModalRoute()
      : super(
          child: const SendProfileModal(),
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

class SearchEmojiRoute extends BaseRouteData {
  SearchEmojiRoute()
      : super(
          child: const SearchEmojiModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ShareViaMessageModalRoute extends BaseRouteData {
  ShareViaMessageModalRoute({
    required this.eventReference,
  }) : super(
          child: ShareViaMessageModal(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
          type: IceRouteType.bottomSheet,
        );

  final String eventReference;
}

class PaymentSelectionChatRoute extends BaseRouteData {
  PaymentSelectionChatRoute({
    required this.pubkey,
  }) : super(
          child: PaymentSelectionModal(
            pubkey: pubkey,
            selectCoinRouteLocationBuilder: (paymentType) =>
                SelectCoinChatRoute(paymentType: paymentType).location,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
}

class SelectCoinChatRoute extends BaseRouteData {
  SelectCoinChatRoute({required this.paymentType})
      : super(
          child: switch (paymentType) {
            PaymentType.send => SendCoinModalPage(
                selectNetworkRouteLocationBuilder: () =>
                    SelectNetworkChatRoute(paymentType: paymentType).location,
              ),
            PaymentType.request => RequestCoinsModalPage(
                selectNetworkLocationRouteBuilder: (paymentType) =>
                    SelectNetworkChatRoute(paymentType: paymentType).location,
              ),
          },
          type: IceRouteType.bottomSheet,
        );

  final PaymentType paymentType;
}

class SelectNetworkChatRoute extends BaseRouteData {
  SelectNetworkChatRoute({required this.paymentType})
      : super(
          child: NetworkListView(
            type: switch (paymentType) {
              PaymentType.send => NetworkListViewType.send,
              PaymentType.request => NetworkListViewType.request,
            },
            sendFormRouteLocationBuilder: () => switch (paymentType) {
              PaymentType.send => SendCoinsFormChatRoute().location,
              PaymentType.request => RequestCoinsFormChatRoute().location,
            },
          ),
          type: IceRouteType.bottomSheet,
        );

  final PaymentType paymentType;
}

class AddressNotFoundChatRoute extends BaseRouteData {
  AddressNotFoundChatRoute()
      : super(
          child: AddressNotFoundChatModal(
            onWalletCreated: (context) => RequestCoinsFormChatRoute().replace(context),
          ),
          type: IceRouteType.bottomSheet,
        );
}

class CoinSendScanChatRoute extends BaseRouteData {
  CoinSendScanChatRoute()
      : super(
          child: const WalletScanModalPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SendCoinsFormChatRoute extends BaseRouteData {
  SendCoinsFormChatRoute()
      : super(
          child: SendCoinsForm(
            selectCoinRouteLocationBuilder: () =>
                SelectCoinChatRoute(paymentType: PaymentType.send).location,
            selectNetworkRouteLocationBuilder: () =>
                SelectNetworkChatRoute(paymentType: PaymentType.send).location,
            selectContactRouteLocationBuilder: (networkId) =>
                SelectContactChatRoute(networkId: networkId).location,
            scanAddressRouteLocationBuilder: () => CoinSendScanChatRoute().location,
            confirmRouteLocationBuilder: () => SendCoinsConfirmationChatRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class SelectContactChatRoute extends BaseRouteData {
  SelectContactChatRoute({required this.networkId})
      : super(
          child: ContactPickerModal(
            networkId: networkId,
            validatorType: ContactPickerValidatorType.networkWallet,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String networkId;
}

class SendCoinsConfirmationChatRoute extends BaseRouteData {
  SendCoinsConfirmationChatRoute()
      : super(
          child: ConfirmationSheet(
            successRouteLocationBuilder: () => CoinTransactionResultChatRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class CoinTransactionResultChatRoute extends BaseRouteData {
  CoinTransactionResultChatRoute()
      : super(
          child: TransactionResultSheet(
            transactionDetailsRouteLocationBuilder: () =>
                CoinTransactionDetailsChatRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class CoinTransactionDetailsChatRoute extends BaseRouteData {
  CoinTransactionDetailsChatRoute()
      : super(
          child: TransactionDetailsPage(
            exploreRouteLocationBuilder: (url) =>
                ExploreTransactionDetailsChatRoute(url: url).location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class ExploreTransactionDetailsChatRoute extends BaseRouteData {
  ExploreTransactionDetailsChatRoute({required this.url})
      : super(
          child: ExploreTransactionDetailsModal(url: url),
          type: IceRouteType.bottomSheet,
        );

  final String url;
}

class RequestCoinsFormChatRoute extends BaseRouteData {
  RequestCoinsFormChatRoute()
      : super(
          child: RequestCoinsFormModal(
            addressNotFoundRouteLocationBuilder: () => AddressNotFoundChatRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

@TypedGoRoute<ChatMediaRoute>(path: '/chat-media/:eventReference/:initialIndex')
class ChatMediaRoute extends BaseRouteData {
  ChatMediaRoute({
    required this.eventReference,
    required this.initialIndex,
  }) : super(
          child: ChatMediaPage(
            eventReference: EventReference.fromEncoded(eventReference),
            initialIndex: initialIndex,
          ),
          type: IceRouteType.swipeDismissible,
        );

  final String eventReference;
  final int initialIndex;
}
