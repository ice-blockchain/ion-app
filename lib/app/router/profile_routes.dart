// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class ProfileRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<ProfileRoute>(path: 'user/:pubkey'),
    TypedGoRoute<ProfileEditRoute>(path: 'profile_edit'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<FollowListRoute>(path: 'follow-list'),
        TypedGoRoute<CategorySelectRoute>(path: 'category-selector'),
        TypedGoRoute<SelectCoinRoute>(path: 'coin-selector'),
        TypedGoRoute<SelectNetworkRoute>(path: 'network-selector'),
        TypedGoRoute<PaymentSelectionRoute>(path: 'payment-selector'),
        TypedGoRoute<SendCoinsFormRoute>(path: 'send-coins-form'),
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

class SelectCoinRoute extends BaseRouteData {
  SelectCoinRoute({
    required this.paymentType,
    required this.pubkey,
    required this.selectCoinModalType,
  }) : super(
          child: SelectCoinModal(
            pubkey: pubkey,
            paymentType: paymentType,
            type: selectCoinModalType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final PaymentType paymentType;
  final String pubkey;
  final SelectCoinModalType selectCoinModalType;
}

class SelectNetworkRoute extends BaseRouteData {
  SelectNetworkRoute({
    required this.paymentType,
    required this.coinSymbolGroup,
    required this.coinAbbreviation,
    required this.pubkey,
    required this.selectNetworkModalType,
  }) : super(
          child: SelectNetworkModal(
            pubkey: pubkey,
            coinSymbolGroup: coinSymbolGroup,
            coinAbbreviation: coinAbbreviation,
            paymentType: paymentType,
            type: selectNetworkModalType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
  final String coinSymbolGroup;
  final String coinAbbreviation;
  final PaymentType paymentType;
  final SelectNetworkModalType selectNetworkModalType;
}

class SendCoinsFormRoute extends BaseRouteData {
  SendCoinsFormRoute({
    required this.pubkey,
    required this.networkId,
    required this.coinSymbolGroup,
    required this.coinAbbreviation,
  }) : super(
          child: SendCoinFormModal(
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
