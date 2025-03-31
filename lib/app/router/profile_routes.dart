// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class ProfileRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<ProfileRoute>(path: 'user/:pubkey'),
    TypedGoRoute<ProfileVideosRoute>(path: 'user-videos-fullstack/:pubkey'),
    TypedGoRoute<ProfileEditRoute>(path: 'profile_edit'),
    TypedGoRoute<FollowListRoute>(path: 'follow-list-fullstack'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<CategorySelectRoute>(path: 'category-selector'),
        TypedGoRoute<SelectCoinProfileRoute>(path: 'coin-selector'),
        TypedGoRoute<SelectNetworkProfileRoute>(path: 'network-selector'),
        TypedGoRoute<PaymentSelectionRoute>(path: 'payment-selector'),
        TypedGoRoute<SendCoinsFormProfileRoute>(path: 'send-coins-form'),
        TypedGoRoute<SendCoinsConfirmationProfileRoute>(path: 'send-form-confirmation'),
        TypedGoRoute<CoinTransactionResultProfileRoute>(path: 'coin-transaction-result'),
        TypedGoRoute<CoinTransactionDetailsProfileRoute>(path: 'coin-transaction-details'),
        TypedGoRoute<ExploreTransactionDetailsProfileRoute>(path: 'coin-transaction-explore'),
        TypedGoRoute<RequestCoinsFormRoute>(path: 'request-coins-form'),
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
          type: IceRouteType.simpleModalSheet,
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

class PaymentSelectionRoute extends BaseRouteData {
  PaymentSelectionRoute({
    required this.pubkey,
  }) : super(
          child: PaymentSelectionModal(
            pubkey: pubkey,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
}

class SelectCoinProfileRoute extends BaseRouteData {
  SelectCoinProfileRoute()
      : super(
          child: SendCoinModalPage(
            selectNetworkRouteLocationBuilder: () => SelectNetworkProfileRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class SelectNetworkProfileRoute extends BaseRouteData {
  SelectNetworkProfileRoute()
      : super(
          child: NetworkListView(
            sendFormRouteLocationBuilder: () => SendCoinsFormProfileRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class SendCoinsFormProfileRoute extends BaseRouteData {
  SendCoinsFormProfileRoute()
      : super(
          child: SendCoinsForm(
            selectCoinRouteLocationBuilder: () => SelectCoinProfileRoute().location,
            selectNetworkRouteLocationBuilder: () => SelectNetworkProfileRoute().location,
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
  RequestCoinsFormRoute({
    required this.pubkey,
    required this.networkId,
    required this.coinSymbolGroup,
    required this.coinAbbreviation,
  }) : super(
          child: RequestCoinsFormModal(
            pubkey: pubkey,
            networkId: networkId,
            coinSymbolGroup: coinSymbolGroup,
            coinAbbreviation: coinAbbreviation,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
  final String networkId;
  final String coinSymbolGroup;
  final String coinAbbreviation;
}
