import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/auth/views/pages/check_email/check_email.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/discover_creators.dart';
import 'package:ice/app/features/auth/views/pages/enter_code/enter_code.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/intro_page.dart';
import 'package:ice/app/features/auth/views/pages/nostr_auth/nostr_auth.dart';
import 'package:ice/app/features/auth/views/pages/nostr_login/nostr_login.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/select_languages.dart';
import 'package:ice/app/features/chat/views/pages/chat_main_modal/chat_main_modal_page.dart';
import 'package:ice/app/features/chat/views/pages/chat_page/chat_page.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/pages/dapp_details/dapp_details.dart';
import 'package:ice/app/features/dapps/views/pages/dapps.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_list/dapps_list.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_main_modal/dapps_main_modal_page.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/feed_main_modal_page.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/feed_page.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_page.dart';
import 'package:ice/app/features/user/pages/switch_account_page/switch_account_page.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/coin_details_page.dart';
import 'package:ice/app/features/wallet/views/pages/coin_receive_modal/coin_receive_modal.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/manage_coins_page.dart';
import 'package:ice/app/features/wallet/views/pages/nfts_sorting_modal/nfts_sorting_modal.dart';
import 'package:ice/app/features/wallet/views/pages/receive_coins/components/network_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/receive_coins/components/share_address_view.dart';
import 'package:ice/app/features/wallet/views/pages/receive_coins/receive_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/request_contacts_access_modal/request_contacts_access_modal.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/network_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/send_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_main_modal/wallet_main_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/wallet_page.dart';
import 'package:ice/app/features/wallets/pages/create_new_wallet_modal/create_new_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/delete_wallet_modal/delete_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/edit_wallet_modal/edit_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/manage_wallets_modal/manage_wallets_modal.dart';
import 'package:ice/app/features/wallets/pages/wallets_modal/wallets_modal.dart';

const IceRoutes<void> initialPage = IceRoutes.splash;

List<IceRoutes<dynamic>> iceRootRoutes = <IceRoutes<dynamic>>[
  IceRoutes.splash,
  IceRoutes.error,
  IceRoutes.intro,
  IceRoutes.home,
  IceRoutes.pullRightMenu,
];

enum IceRoutes<PayloadType> {
  splash(SplashPage.new),
  error(ErrorPage.new),
  intro(
    IntroPage.new,
    children: <IceRoutes<dynamic>>[
      IceRoutes.auth,
      IceRoutes.selectCountries,
      IceRoutes.selectLanguages,
      IceRoutes.checkEmail,
      IceRoutes.fillProfile,
      IceRoutes.discoverCreators,
      IceRoutes.nostrAuth,
      IceRoutes.nostrLogin,
      IceRoutes.enterCode,
    ],
  ),
  auth(
    AuthPage.new,
    type: IceRouteType.bottomSheet,
  ),
  selectCountries(
    SelectCountries.new,
    type: IceRouteType.bottomSheet,
  ),
  selectLanguages(
    SelectLanguages.new,
    type: IceRouteType.bottomSheet,
  ),
  checkEmail(
    CheckEmail.new,
    type: IceRouteType.bottomSheet,
  ),
  nostrAuth(
    NostrAuth.new,
    type: IceRouteType.bottomSheet,
  ),
  nostrLogin(
    NostrLogin.new,
    type: IceRouteType.bottomSheet,
  ),
  enterCode(
    EnterCode.new,
    type: IceRouteType.bottomSheet,
  ),
  discoverCreators(
    DiscoverCreators.new,
    type: IceRouteType.bottomSheet,
  ),
  fillProfile(
    FillProfile.new,
    type: IceRouteType.bottomSheet,
  ),
  home(
    null,
    type: IceRouteType.bottomTabs,
    children: <IceRoutes<dynamic>>[
      IceRoutes.feed,
      IceRoutes.dapps,
      IceRoutes.chat,
      IceRoutes.wallet,
    ],
  ),
  feed(
    FeedPage.new,
    children: <IceRoutes<dynamic>>[IceRoutes.feedMainModal],
  ),
  feedMainModal(
    FeedMainModalPage.new,
    type: IceRouteType.bottomSheet,
  ),
  dapps(
    DAppsPage.new,
    children: <IceRoutes<dynamic>>[
      IceRoutes.appsList,
      IceRoutes.dappsDetails,
      IceRoutes.dappsMainModal,
    ],
  ),
  dappsMainModal(
    DappsMainModalPage.new,
    type: IceRouteType.bottomSheet,
  ),
  appsList<AppsRouteData>(DAppsList.new),
  pullRightMenu(
    PullRightMenuPage.new,
    type: IceRouteType.slideFromLeft,
    children: <IceRoutes<dynamic>>[
      IceRoutes.switchAccount,
    ],
  ),
  switchAccount(
    SwitchAccountPage.new,
    type: IceRouteType.bottomSheet,
  ),
  chat(
    ChatPage.new,
    children: <IceRoutes<dynamic>>[
      IceRoutes.chatMainModal,
    ],
  ),
  chatMainModal(
    ChatMainModalPage.new,
    type: IceRouteType.bottomSheet,
  ),
  wallet(
    WalletPage.new,
    children: <IceRoutes<dynamic>>[
      IceRoutes.allowAccess,
      IceRoutes.nftsSorting,
      IceRoutes.walletMainModal,
      IceRoutes.coinSend,
      IceRoutes.receiveCoin,
      IceRoutes.networkSelect,
      IceRoutes.networkSelectReceive,
      IceRoutes.shareAddress,
      IceRoutes.coinDetails,
      IceRoutes.coinReceive,
      IceRoutes.manageCoins,
      IceRoutes.wallets,
      IceRoutes.manageWallets,
      IceRoutes.createWallet,
      IceRoutes.editWallet,
      IceRoutes.deleteWallet,
    ],
  ),
  wallets(
    WalletsModal.new,
    type: IceRouteType.bottomSheet,
  ),
  manageWallets(
    ManageWalletsModal.new,
    type: IceRouteType.bottomSheet,
  ),
  createWallet(
    CreateNewWalletModal.new,
    type: IceRouteType.bottomSheet,
  ),
  editWallet(
    EditWalletModal.new,
    type: IceRouteType.bottomSheet,
  ),
  deleteWallet(
    DeleteWalletModal.new,
    type: IceRouteType.bottomSheet,
  ),
  walletMainModal(
    WalletMainModalPage.new,
    type: IceRouteType.bottomSheet,
  ),
  allowAccess(
    RequestContactAccessModal.new,
    type: IceRouteType.bottomSheet,
  ),
  nftsSorting(
    NftsSortingModal.new,
    type: IceRouteType.bottomSheet,
  ),
  coinSend(
    SendCoinModalPage.new,
    type: IceRouteType.bottomSheet,
  ),
  receiveCoin(
    ReceiveCoinModalPage.new,
    type: IceRouteType.bottomSheet,
  ),
  coinReceive(
    CoinReceiveModal.new,
    type: IceRouteType.bottomSheet,
  ),
  networkSelect(
    NetworkListView.new,
    type: IceRouteType.bottomSheet,
  ),
  networkSelectReceive(
    NetworkListReceiveView.new,
    type: IceRouteType.bottomSheet,
  ),
  shareAddress(
    ShareAddressView.new,
    type: IceRouteType.bottomSheet,
  ),
  manageCoins(
    ManageCoinsPage.new,
    type: IceRouteType.bottomSheet,
  ),
  coinDetails<CoinData>(CoinDetailsPage.new),
  dappsDetails(
    DAppDetails.new,
    type: IceRouteType.bottomSheet,
  ),
  ;

  const IceRoutes(
    this.builder, {
    this.type = IceRouteType.single,
    this.children,
  });

  final IceRouteType type;
  final List<IceRoutes<dynamic>>? children;
  final IcePageBuilder<PayloadType>? builder;

  String get routeName => name;

  void go(BuildContext context, {PayloadType? payload}) =>
      context.goNamed(routeName, extra: payload);

  Future<T?> push<T extends Object?>(
    BuildContext context, {
    PayloadType? payload,
  }) =>
      context.pushNamed(routeName, extra: payload);

  void pushReplacement(BuildContext context, {PayloadType? payload}) =>
      context.pushReplacementNamed(routeName, extra: payload);

  void replace(BuildContext context, {PayloadType? payload}) =>
      context.replaceNamed(routeName, extra: payload);
}

typedef IcePageBuilder<PayloadType> = IcePage<PayloadType> Function(
  IceRoutes<PayloadType> route,
  dynamic payload,
);

enum IceRouteType {
  single,
  bottomSheet,
  slideFromLeft,
  bottomTabs,
  ;
}
