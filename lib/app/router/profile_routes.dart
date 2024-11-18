// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class ProfileRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<ProfileRoute>(path: 'profile/:pubkey'),
    TypedGoRoute<ProfileEditRoute>(path: 'profile_edit'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<FollowListRoute>(path: 'follow-list'),
        TypedGoRoute<CategorySelectRoute>(path: 'category-selector'),
        TypedGoRoute<BannerPickerRoute>(path: 'pick-banner'),
        TypedGoRoute<SelectCoinRoute>(path: 'coin-selector'),
        TypedGoRoute<SelectNetworkRoute>(path: 'network-selector'),
        TypedGoRoute<PaymentSelectionRoute>(path: 'payment-selector'),
        TypedGoRoute<SendCoinsFormRoute>(path: 'send-coins-form'),
        TypedGoRoute<RequestCoinsFormRoute>(path: 'request-coins-form'),
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
  ProfileEditRoute({required this.pubkey})
      : super(
          child: ProfileEditPage(pubkey: pubkey),
        );

  final String pubkey;
}

class BannerPickerRoute extends BaseRouteData {
  BannerPickerRoute({required this.pubkey})
      : super(
          child: const MediaPickerPage(
            maxSelection: 1,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
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
    required this.selectedUserCategoryType,
    required this.pubkey,
  }) : super(
          child: CategorySelectModal(
            selectedUserCategoryType: selectedUserCategoryType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final UserCategoryType? selectedUserCategoryType;
  final String pubkey;
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
    required this.coinId,
    required this.pubkey,
    required this.selectNetworkModalType,
  }) : super(
          child: SelectNetworkModal(
            pubkey: pubkey,
            coinId: coinId,
            paymentType: paymentType,
            type: selectNetworkModalType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final PaymentType paymentType;
  final String coinId;
  final String pubkey;
  final SelectNetworkModalType selectNetworkModalType;
}

class SendCoinsFormRoute extends BaseRouteData {
  SendCoinsFormRoute({
    required this.networkType,
    required this.coinId,
    required this.pubkey,
  }) : super(
          child: SendCoinFormModal(
            pubkey: pubkey,
            coinId: coinId,
            networkType: networkType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final NetworkType networkType;
  final String coinId;
  final String pubkey;
}

class RequestCoinsFormRoute extends BaseRouteData {
  RequestCoinsFormRoute({
    required this.networkType,
    required this.coinId,
    required this.pubkey,
  }) : super(
          child: RequestCoinsFormModal(
            pubkey: pubkey,
            coinId: coinId,
            networkType: networkType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final NetworkType networkType;
  final String coinId;
  final String pubkey;
}
