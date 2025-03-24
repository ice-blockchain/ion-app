// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class WalletRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [TypedGoRoute<AllowAccessRoute>(path: 'allow-access')],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [TypedGoRoute<ManageNftsRoute>(path: 'manage-nfts')],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<SelectContactRoute>(path: 'select-contact'),
        TypedGoRoute<ContactRoute>(path: 'one-contact/:pubkey'),
        ...coinSendRoutes,
        ...coinReceiveRoutes,
      ],
    ),
    ...walletManagementRoutes,
    ...nftSendRoutes,
    TypedShellRoute<ModalShellRouteData>(
      routes: [TypedGoRoute<ScanWalletRoute>(path: 'scan-wallet')],
    ),
    TypedGoRoute<CoinsDetailsRoute>(path: 'coin-details'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<CoinReceiveRoute>(path: 'coin-receive'),
        TypedGoRoute<ShareAddressCoinDetailsRoute>(path: 'share-wallet-address'),
        TypedGoRoute<ChangeNetworkShareWalletRoute>(path: 'change-wallet-network'),
      ],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<ManageCoinsRoute>(path: 'manage-coins'),
        TypedGoRoute<ImportTokenRoute>(path: 'import-token'),
        TypedGoRoute<SelectNetworkForTokenRoute>(path: 'select-network'),
      ],
    ),
    ...DappsRoutes.routes,
  ];

  static const nftSendRoutes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<NftDetailsRoute>(path: 'nft-details'),
        TypedGoRoute<ManageNftsRoute>(path: 'manage-nfts'),
        TypedGoRoute<NftSendFormRoute>(
          path: 'nft-send',
          routes: [
            TypedGoRoute<NftSelectContactRoute>(path: 'select-contact-to-send-nft'),
          ],
        ),
        TypedGoRoute<NftSendScanRoute>(path: 'scan-receiver-wallet'),
        TypedGoRoute<SendNftConfirmRoute>(path: 'nft-confirm'),
        TypedGoRoute<NftTransactionResultRoute>(path: 'nft-transaction-result'),
        TypedGoRoute<NftTransactionDetailsRoute>(path: 'nft-transaction-details'),
        TypedGoRoute<ExploreNftTransactionDetailsRoute>(path: 'explore-nft-transaction-details'),
      ],
    ),
  ];

  static const coinSendRoutes = <TypedRoute<RouteData>>[
    TypedGoRoute<CoinSendRoute>(
      path: 'coin-send',
      routes: [
        TypedGoRoute<NetworkSelectSendRoute>(path: 'network-select'),
        TypedGoRoute<CoinsSendFormRoute>(
          path: 'coin-send-form',
          routes: [
            TypedGoRoute<CoinsSelectContactRoute>(path: 'select-contact-to-send_coins'),
            TypedGoRoute<ShareAddressDepositRoute>(path: 'share-address-to-deposit'),
          ],
        ),
        TypedGoRoute<CoinSendScanRoute>(path: 'scan-receiver-wallet'),
        TypedGoRoute<CoinsSendFormConfirmationRoute>(
          path: 'coin-send-form-confirmation',
        ),
      ],
    ),
    TypedGoRoute<CoinTransactionResultRoute>(path: 'coin-transaction-result'),
    TypedGoRoute<CoinTransactionDetailsRoute>(path: 'coin-transaction-details'),
    TypedGoRoute<ExploreCoinTransactionDetailsRoute>(path: 'explore-coin-transaction-details'),
  ];

  static const coinReceiveRoutes = <TypedRoute<RouteData>>[
    TypedGoRoute<ReceiveCoinRoute>(
      path: 'receive-coin',
      routes: [
        TypedGoRoute<NetworkSelectReceiveRoute>(path: 'network-select-receive'),
      ],
    ),
    TypedGoRoute<ShareAddressRoute>(path: 'share-address'),
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

class ManageNftsRoute extends BaseRouteData {
  ManageNftsRoute()
      : super(
          child: const ManageNftsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinSendScanRoute extends BaseRouteData {
  CoinSendScanRoute()
      : super(
          child: const WalletScanModalPage(),
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

class NetworkSelectReceiveRoute extends BaseRouteData {
  NetworkSelectReceiveRoute()
      : super(
          child: const NetworkListView(type: NetworkListViewType.receive),
          type: IceRouteType.bottomSheet,
        );
}

class NetworkSelectSendRoute extends BaseRouteData {
  NetworkSelectSendRoute()
      : super(
          child: const NetworkListView(),
          type: IceRouteType.bottomSheet,
        );
}

class ChangeNetworkShareWalletRoute extends BaseRouteData {
  ChangeNetworkShareWalletRoute()
      : super(
          child: const NetworkListView(
            type: NetworkListViewType.receive,
            onSelectReturnType: true,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class ShareAddressCoinDetailsRoute extends BaseRouteData {
  ShareAddressCoinDetailsRoute()
      : super(
          child: const ShareAddressView(),
          type: IceRouteType.bottomSheet,
        );
}

class ShareAddressDepositRoute extends BaseRouteData {
  ShareAddressDepositRoute()
      : super(
          child: const ShareAddressView(),
          type: IceRouteType.bottomSheet,
        );
}

class ShareAddressRoute extends BaseRouteData {
  ShareAddressRoute()
      : super(
          child: const ShareAddressView(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinsSendFormRoute extends BaseRouteData {
  CoinsSendFormRoute()
      : super(
          child: const SendCoinsForm(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinsSelectContactRoute extends BaseRouteData {
  CoinsSelectContactRoute({required this.networkId})
      : super(
          child: ContactPickerModal(
            networkId: networkId,
            validatorType: ContactPickerValidatorType.networkWallet,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String networkId;
}

class SelectContactRoute extends BaseRouteData {
  SelectContactRoute()
      : super(
          child: const ContactPickerModal(),
          type: IceRouteType.bottomSheet,
        );
}

class NftSelectContactRoute extends BaseRouteData {
  NftSelectContactRoute({required this.networkId})
      : super(
          child: ContactPickerModal(
            networkId: networkId,
            validatorType: ContactPickerValidatorType.networkWallet,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String networkId;
}

class CoinsSendFormConfirmationRoute extends BaseRouteData {
  CoinsSendFormConfirmationRoute()
      : super(
          child: const ConfirmationSheet(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinTransactionResultRoute extends BaseRouteData {
  CoinTransactionResultRoute()
      : super(
          child: const TransactionResultSheet(type: CryptoAssetType.coin),
          type: IceRouteType.bottomSheet,
        );
}

class NftTransactionResultRoute extends BaseRouteData {
  NftTransactionResultRoute()
      : super(
          child: const TransactionResultSheet(type: CryptoAssetType.nft),
          type: IceRouteType.bottomSheet,
        );
}

class CoinsDetailsRoute extends BaseRouteData {
  CoinsDetailsRoute({required this.symbolGroup})
      : super(
          child: CoinDetailsPage(symbolGroup: symbolGroup),
        );

  final String symbolGroup;
}

class CoinReceiveRoute extends BaseRouteData {
  CoinReceiveRoute()
      : super(
          child: const CoinReceiveModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ManageCoinsRoute extends BaseRouteData {
  ManageCoinsRoute()
      : super(
          child: const ManageCoinsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class ImportTokenRoute extends BaseRouteData {
  ImportTokenRoute()
      : super(
          child: const ImportTokenPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SelectNetworkForTokenRoute extends BaseRouteData {
  SelectNetworkForTokenRoute()
      : super(
          child: const SelectNetworkList(),
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
  EditWalletRoute({required this.walletId})
      : super(
          child: EditWalletModal(walletId: walletId),
          type: IceRouteType.bottomSheet,
        );

  final String walletId;
}

class DeleteWalletRoute extends BaseRouteData {
  DeleteWalletRoute({required this.walletId})
      : super(
          child: DeleteWalletModal(walletId: walletId),
          type: IceRouteType.bottomSheet,
        );

  final String walletId;
}

class ContactRoute extends BaseRouteData {
  ContactRoute({required this.pubkey})
      : super(
          child: ContactPage(pubkey: pubkey),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
}

class NftDetailsRoute extends BaseRouteData {
  NftDetailsRoute({
    required this.contract,
    required this.tokenId,
  }) : super(
          child: NftDetailsPage(
            contract: contract,
            tokenId: tokenId,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String contract;
  final String tokenId;
}

class NftSendFormRoute extends BaseRouteData {
  NftSendFormRoute()
      : super(
          child: const SendNftForm(),
          type: IceRouteType.bottomSheet,
        );
}

class NftSendScanRoute extends BaseRouteData {
  NftSendScanRoute()
      : super(
          child: const WalletScanModalPage(),
          type: IceRouteType.bottomSheet,
        );
}

class SendNftConfirmRoute extends BaseRouteData {
  SendNftConfirmRoute()
      : super(
          child: const SendNftConfirmPage(),
          type: IceRouteType.bottomSheet,
        );
}

class NftTransactionDetailsRoute extends BaseRouteData {
  NftTransactionDetailsRoute()
      : super(
          child: const TransactionDetailsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class CoinTransactionDetailsRoute extends BaseRouteData {
  CoinTransactionDetailsRoute()
      : super(
          child: const TransactionDetailsPage(),
          type: IceRouteType.bottomSheet,
        );
}

class ExploreNftTransactionDetailsRoute extends BaseRouteData {
  ExploreNftTransactionDetailsRoute({required this.url})
      : super(
          child: ExploreTransactionDetailsModal(url: url),
          type: IceRouteType.bottomSheet,
        );

  final String url;
}

class ExploreCoinTransactionDetailsRoute extends BaseRouteData {
  ExploreCoinTransactionDetailsRoute({required this.url})
      : super(
          child: ExploreTransactionDetailsModal(url: url),
          type: IceRouteType.bottomSheet,
        );

  final String url;
}
