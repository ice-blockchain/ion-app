// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class WalletRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedShellRoute<ModalShellRouteData>(
      routes: [TypedGoRoute<ManageNftsRoute>(path: 'manage-nfts')],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<SelectContactRoute>(path: 'select-contact'),
        TypedGoRoute<ContactRoute>(path: 'one-contact/:pubkey'),
        TypedGoRoute<CoinTransactionDetailsRoute>(path: 'transaction-details'),
        TypedGoRoute<ExploreTransactionDetailsRoute>(path: 'explore-transaction-details'),
        ...coinSendRoutes,
        ...coinReceiveRoutes,
        ...nftSendRoutes,
      ],
    ),
    ...walletManagementRoutes,
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
    TypedGoRoute<NftDetailsRoute>(path: 'nft-details'),
    TypedGoRoute<NftSendFormRoute>(
      path: 'nft-send',
      routes: [
        TypedGoRoute<NftSelectContactRoute>(path: 'select-contact-to-send-nft'),
        TypedGoRoute<NftSendScanRoute>(path: 'scan-receiver-wallet'),
        TypedGoRoute<SendNftConfirmRoute>(path: 'nft-confirm'),
        TypedGoRoute<NftTransactionResultRoute>(path: 'nft-transaction-result'),
      ],
    ),
  ];

  static const coinSendRoutes = <TypedRoute<RouteData>>[
    TypedGoRoute<SelectCoinWalletRoute>(
      path: 'coin-send',
      routes: [
        TypedGoRoute<SelectNetworkWalletRoute>(path: 'network-select'),
        TypedGoRoute<SendCoinsFormWalletRoute>(
          path: 'coin-send-form',
          routes: [
            TypedGoRoute<SelectContactWalletRoute>(path: 'select-contact-to-send_coins'),
            TypedGoRoute<ShareAddressDepositRoute>(path: 'share-address-to-deposit'),
          ],
        ),
        TypedGoRoute<CoinSendScanRoute>(path: 'scan-receiver-wallet'),
        TypedGoRoute<SendCoinsConfirmationWalletRoute>(path: 'coin-send-form-confirmation'),
      ],
    ),
    TypedGoRoute<CoinTransactionResultWalletRoute>(path: 'coin-transaction-result'),
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

class SelectCoinWalletRoute extends BaseRouteData {
  SelectCoinWalletRoute()
      : super(
          child: SendCoinModalPage(
            selectNetworkRouteLocationBuilder: () => SelectNetworkWalletRoute().location,
          ),
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

class SelectNetworkWalletRoute extends BaseRouteData {
  SelectNetworkWalletRoute()
      : super(
          child: NetworkListView(
            sendFormRouteLocationBuilder: () => SendCoinsFormWalletRoute().location,
          ),
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

class SendCoinsFormWalletRoute extends BaseRouteData {
  SendCoinsFormWalletRoute()
      : super(
          child: SendCoinsForm(
            selectCoinRouteLocationBuilder: () => SelectCoinWalletRoute().location,
            selectNetworkRouteLocationBuilder: () => SelectNetworkWalletRoute().location,
            selectContactRouteLocationBuilder: (networkId) =>
                SelectContactWalletRoute(networkId: networkId).location,
            scanAddressRouteLocationBuilder: () => CoinSendScanRoute().location,
            confirmRouteLocationBuilder: () => SendCoinsConfirmationWalletRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class SelectContactWalletRoute extends BaseRouteData {
  SelectContactWalletRoute({required this.networkId})
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

class SendCoinsConfirmationWalletRoute extends BaseRouteData {
  SendCoinsConfirmationWalletRoute()
      : super(
          child: ConfirmationSheet(
            successRouteLocationBuilder: () => CoinTransactionResultWalletRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class CoinTransactionResultWalletRoute extends BaseRouteData {
  CoinTransactionResultWalletRoute()
      : super(
          child: TransactionResultSheet(
            transactionDetailsRouteLocationBuilder: () => CoinTransactionDetailsRoute().location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class NftTransactionResultRoute extends BaseRouteData {
  NftTransactionResultRoute()
      : super(
          child: TransactionResultSheet(
            transactionDetailsRouteLocationBuilder: () => CoinTransactionDetailsRoute().location,
          ),
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

class CoinTransactionDetailsRoute extends BaseRouteData {
  CoinTransactionDetailsRoute()
      : super(
          child: TransactionDetailsPage(
            exploreRouteLocationBuilder: (url) => ExploreTransactionDetailsRoute(url: url).location,
          ),
          type: IceRouteType.bottomSheet,
        );
}

class ExploreTransactionDetailsRoute extends BaseRouteData {
  ExploreTransactionDetailsRoute({required this.url})
      : super(
          child: ExploreTransactionDetailsModal(url: url),
          type: IceRouteType.bottomSheet,
        );

  final String url;
}
