part of 'app_routes.dart';

class WalletRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [TypedGoRoute<AllowAccessRoute>(path: 'allow-access')],
    ),
    TypedGoRoute<NftsSortingRoute>(path: 'nfts-sorting'),
    ...coinSendRoutes,
    ...coinReceiveRoutes,
    ...walletManagementRoutes,
    TypedShellRoute<ModalShellRouteData>(
      routes: [TypedGoRoute<ScanWalletRoute>(path: 'scan-wallet')],
    ),
    TypedGoRoute<ContactsSelectRoute>(path: 'contacts-select'),
    TypedGoRoute<CoinsDetailsRoute>(path: 'coin-details'),
    TypedGoRoute<CoinReceiveRoute>(path: 'coin-receive'),
    TypedGoRoute<ManageCoinsRoute>(path: 'manage-coins'),
  ];

  static const coinSendRoutes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<CoinSendRoute>(path: 'coin-send'),
        TypedGoRoute<NetworkSelectRoute>(path: 'network-select'),
        TypedGoRoute<CoinsSendFormRoute>(path: 'coin-send-form'),
        TypedGoRoute<CoinsSendFormConfirmationRoute>(
          path: 'coin-send-form-confirmation',
        ),
        TypedGoRoute<TransactionResultRoute>(path: 'transaction-result'),
      ],
    ),
  ];

  static const coinReceiveRoutes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<ReceiveCoinRoute>(path: 'receive-coin'),
        TypedGoRoute<NetworkSelectReceiveRoute>(path: 'network-select-receive'),
        TypedGoRoute<ShareAddressRoute>(path: 'share-address'),
      ],
    ),
  ];

  static const walletManagementRoutes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<WalletsRoute>(path: 'wallets'),
        TypedGoRoute<ManageWalletsRoute>(path: 'manage-wallets'),
        TypedGoRoute<CreateWalletRoute>(path: 'create-wallet'),
        TypedGoRoute<EditWalletRoute>(path: 'edit-wallet'),
        TypedGoRoute<DeleteWalletRoute>(path: 'delete-wallet'),
      ],
    ),
  ];
}

class AllowAccessRoute extends BaseRouteData {
  AllowAccessRoute()
      : super(
          child: const RequestContactAccessModal(),
          type: IceRouteType.bottomSheet,
        );
}

class NftsSortingRoute extends BaseRouteData {
  NftsSortingRoute()
      : super(
          child: const NftsSortingModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinSendRoute extends BaseRouteData {
  CoinSendRoute()
      : super(
          child: const SendCoinModalPage(),
          type: IceRouteType.bottomSheet,
        );
}

class ReceiveCoinRoute extends BaseRouteData {
  ReceiveCoinRoute()
      : super(
          child: const ReceiveCoinModalPage(),
          type: IceRouteType.bottomSheet,
        );
}

class ScanWalletRoute extends BaseRouteData {
  ScanWalletRoute()
      : super(
          child: const WalletScanModalPage(),
          type: IceRouteType.bottomSheet,
        );
}

class NetworkSelectRoute extends BaseRouteData {
  NetworkSelectRoute()
      : super(
          child: const NetworkListView(),
          type: IceRouteType.bottomSheet,
        );
}

class NetworkSelectReceiveRoute extends BaseRouteData {
  NetworkSelectReceiveRoute({required this.$extra})
      : super(
          child: NetworkListReceiveView(payload: $extra),
          type: IceRouteType.bottomSheet,
        );

  final CoinData $extra;
}

class ShareAddressRoute extends BaseRouteData {
  ShareAddressRoute({required this.$extra})
      : super(
          child: ShareAddressView(payload: $extra),
          type: IceRouteType.bottomSheet,
        );

  final Map<String, dynamic> $extra;
}

class CoinsSendFormRoute extends BaseRouteData {
  CoinsSendFormRoute()
      : super(
          child: const SendCoinsForm(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinsSendFormConfirmationRoute extends BaseRouteData {
  CoinsSendFormConfirmationRoute()
      : super(
          child: const ConfirmationSheet(),
          type: IceRouteType.bottomSheet,
        );
}

class TransactionResultRoute extends BaseRouteData {
  TransactionResultRoute()
      : super(
          child: const TransactionResultSheet(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinsDetailsRoute extends BaseRouteData {
  CoinsDetailsRoute({required this.$extra})
      : super(child: CoinDetailsPage(payload: $extra));

  final CoinData $extra;
}

class CoinReceiveRoute extends BaseRouteData {
  CoinReceiveRoute({required this.$extra})
      : super(
          child: CoinReceiveModal(payload: $extra),
          type: IceRouteType.bottomSheet,
        );

  final CoinReceiveModalData $extra;
}

class ManageCoinsRoute extends BaseRouteData {
  ManageCoinsRoute()
      : super(
          child: const ManageCoinsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class WalletsRoute extends BaseRouteData {
  WalletsRoute()
      : super(
          child: const WalletsModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ManageWalletsRoute extends BaseRouteData {
  ManageWalletsRoute()
      : super(
          child: const ManageWalletsModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CreateWalletRoute extends BaseRouteData {
  CreateWalletRoute()
      : super(
          child: const CreateNewWalletModal(),
          type: IceRouteType.bottomSheet,
        );
}

class EditWalletRoute extends BaseRouteData {
  EditWalletRoute({required this.$extra})
      : super(
          child: EditWalletModal(payload: $extra),
          type: IceRouteType.bottomSheet,
        );

  final WalletData $extra;
}

class DeleteWalletRoute extends BaseRouteData {
  DeleteWalletRoute({required this.$extra})
      : super(
          child: DeleteWalletModal(payload: $extra),
          type: IceRouteType.bottomSheet,
        );

  final WalletData $extra;
}
