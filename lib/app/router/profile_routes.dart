// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class ProfileRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<ProfileRoute>(path: 'user/:pubkey'),
    TypedGoRoute<ProfileVideosRoute>(path: 'user-videos-fullstack/:pubkey'),
    TypedGoRoute<ProfileEditRoute>(path: 'profile_edit'),
    TypedGoRoute<BookmarksRoute>(path: 'bookmarks'),
    TypedGoRoute<EditBookmarksRoute>(path: 'bookmarks_edit'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<FollowListRoute>(path: 'follow-list-fullstack'),
        TypedGoRoute<CategorySelectRoute>(path: 'category-selector'),
        TypedGoRoute<SelectCoinProfileRoute>(path: 'coin-selector'),
        TypedGoRoute<SelectNetworkProfileRoute>(path: 'network-selector'),
        TypedGoRoute<PaymentSelectionProfileRoute>(path: 'payment-selector'),
        TypedGoRoute<SendCoinsFormProfileRoute>(path: 'send-coins-form'),
        TypedGoRoute<SendCoinsConfirmationProfileRoute>(path: 'send-form-confirmation'),
        TypedGoRoute<CoinTransactionResultProfileRoute>(path: 'coin-transaction-result'),
        TypedGoRoute<CoinTransactionDetailsProfileRoute>(path: 'coin-transaction-details'),
        TypedGoRoute<ExploreTransactionDetailsProfileRoute>(path: 'coin-transaction-explore'),
        TypedGoRoute<RequestCoinsFormRoute>(path: 'request-coins-form'),
        TypedGoRoute<AddressNotFoundProfileRoute>(path: 'address-not-found'),
        TypedGoRoute<RepostOptionsModalProfileRoute>(
          path: 'profile-post-repost-options/:eventReference',
        ),
        TypedGoRoute<CreateQuoteProfileRoute>(path: 'post-editor/profile-quote/:quotedEvent'),
        ...SettingsRoutes.routes,
      ],
    ),
  ];
}

class ProfileRoute extends BaseRouteData {
  ProfileRoute({required this.pubkey})
      : super(
          child: ProfilePage(pubkey: pubkey),
        );

  final String pubkey;
}

class ProfileVideosRoute extends BaseRouteData {
  ProfileVideosRoute({
    required this.pubkey,
    required this.tabEntityType,
    required this.eventReference,
    this.initialMediaIndex = 0,
    this.framedEventReference,
  }) : super(
          child: ProfileVideosPage(
            pubkey: pubkey,
            tabEntityType: tabEntityType,
            eventReference: EventReference.fromEncoded(eventReference),
            initialMediaIndex: initialMediaIndex,
            framedEventReference: framedEventReference != null
                ? EventReference.fromEncoded(framedEventReference)
                : null,
          ),
          type: IceRouteType.swipeDismissible,
        );

  final String pubkey;
  final TabEntityType tabEntityType;
  final String eventReference;
  final String? framedEventReference;
  final int initialMediaIndex;
}

class ProfileEditRoute extends BaseRouteData {
  ProfileEditRoute()
      : super(
          child: const ProfileEditPage(),
        );
}

class FollowListRoute extends BaseRouteData {
  FollowListRoute({
    required this.followType,
    required this.pubkey,
  }) : super(
          child: FollowListView(
            followType: followType,
            pubkey: pubkey,
          ),
          type: IceRouteType.bottomSheet,
        );

  final FollowType followType;
  final String pubkey;
}

class CategorySelectRoute extends BaseRouteData {
  CategorySelectRoute({
    required this.selectedCategory,
  }) : super(
          child: CategorySelectModal(selectedCategory: selectedCategory),
          type: IceRouteType.bottomSheet,
        );

  final String? selectedCategory;
}

class PaymentSelectionProfileRoute extends BaseRouteData {
  PaymentSelectionProfileRoute({
    required this.pubkey,
  }) : super(
          child: PaymentSelectionModal(
            pubkey: pubkey,
            selectCoinRouteLocationBuilder: (paymentType) =>
                SelectCoinProfileRoute(paymentType: paymentType).location,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
}

class SelectCoinProfileRoute extends BaseRouteData {
  SelectCoinProfileRoute({required this.paymentType})
      : super(
          child: switch (paymentType) {
            PaymentType.send => SendCoinModalPage(
                selectNetworkRouteLocationBuilder: () =>
                    SelectNetworkProfileRoute(paymentType: paymentType).location,
              ),
            PaymentType.request => RequestCoinsModalPage(
                selectNetworkLocationRouteBuilder: (paymentType) =>
                    SelectNetworkProfileRoute(paymentType: paymentType).location,
              ),
          },
          type: IceRouteType.bottomSheet,
        );

  final PaymentType paymentType;
}

class SelectNetworkProfileRoute extends BaseRouteData {
  SelectNetworkProfileRoute({required this.paymentType})
      : super(
          child: NetworkListView(
            type: switch (paymentType) {
              PaymentType.send => NetworkListViewType.send,
              PaymentType.request => NetworkListViewType.request,
            },
            sendFormRouteLocationBuilder: () => switch (paymentType) {
              PaymentType.send => SendCoinsFormProfileRoute().location,
              PaymentType.request => RequestCoinsFormRoute().location,
            },
          ),
          type: IceRouteType.bottomSheet,
        );

  final PaymentType paymentType;
}

class AddressNotFoundProfileRoute extends BaseRouteData {
  AddressNotFoundProfileRoute()
      : super(
          child: AddressNotFoundChatModal(
            onWalletCreated: (context) => RequestCoinsFormRoute().replace(context),
          ),
          type: IceRouteType.bottomSheet,
        );
}

class SendCoinsFormProfileRoute extends BaseRouteData {
  SendCoinsFormProfileRoute()
      : super(
          child: SendCoinsForm(
            selectCoinRouteLocationBuilder: () =>
                SelectCoinProfileRoute(paymentType: PaymentType.send).location,
            selectNetworkRouteLocationBuilder: () =>
                SelectNetworkProfileRoute(paymentType: PaymentType.send).location,
            scanAddressRouteLocationBuilder: () => CoinSendScanRoute().location,
            confirmRouteLocationBuilder: () => SendCoinsConfirmationProfileRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class SendCoinsConfirmationProfileRoute extends BaseRouteData {
  SendCoinsConfirmationProfileRoute()
      : super(
          child: ConfirmationSheet(
            successRouteLocationBuilder: () => CoinTransactionResultProfileRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class CoinTransactionResultProfileRoute extends BaseRouteData {
  CoinTransactionResultProfileRoute()
      : super(
          child: TransactionResultSheet(
            transactionDetailsRouteLocationBuilder: () =>
                CoinTransactionDetailsProfileRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class CoinTransactionDetailsProfileRoute extends BaseRouteData {
  CoinTransactionDetailsProfileRoute()
      : super(
          child: TransactionDetailsPage(
            exploreRouteLocationBuilder: (url) =>
                ExploreTransactionDetailsProfileRoute(url: url).location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class ExploreTransactionDetailsProfileRoute extends BaseRouteData {
  ExploreTransactionDetailsProfileRoute({required this.url})
      : super(
          child: ExploreTransactionDetailsModal(url: url),
          type: IceRouteType.bottomSheet,
        );

  final String url;
}

class RequestCoinsFormRoute extends BaseRouteData {
  RequestCoinsFormRoute()
      : super(
          child: RequestCoinsFormModal(
            addressNotFoundRouteLocationBuilder: () => AddressNotFoundProfileRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class BookmarksRoute extends BaseRouteData {
  BookmarksRoute()
      : super(
          child: const BookmarksPage(),
        );
}

class EditBookmarksRoute extends BaseRouteData {
  EditBookmarksRoute()
      : super(
          child: const EditBookmarksPage(),
        );
}

class RepostOptionsModalProfileRoute extends BaseRouteData {
  RepostOptionsModalProfileRoute({
    required this.eventReference,
  }) : super(
          child: RepostOptionsModal(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
          type: IceRouteType.bottomSheet,
        );

  final String eventReference;
}

class AlbumSelectionProfileRoute extends BaseRouteData {
  AlbumSelectionProfileRoute({
    required this.mediaPickerType,
  }) : super(
          child: AlbumSelectionPage(type: mediaPickerType),
          type: IceRouteType.bottomSheet,
        );

  final MediaPickerType mediaPickerType;
}

class CreateQuoteProfileRoute extends BaseRouteData {
  CreateQuoteProfileRoute({
    required this.quotedEvent,
    this.content,
    this.attachedMedia,
  }) : super(
          child: PostFormModal.createQuote(
            quotedEvent: EventReference.fromEncoded(quotedEvent),
            content: content,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String quotedEvent;
  final String? content;
  final String? attachedMedia;
}
