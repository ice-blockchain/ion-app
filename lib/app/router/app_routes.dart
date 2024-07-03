import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
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
import 'package:ice/app/features/chat/views/pages/chat_page/chat_page.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/not_found_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/pages/dapp_details/dapp_details.dart';
import 'package:ice/app/features/dapps/views/pages/dapps.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_list/dapps_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/feed_main_modal_page.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/feed_page.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_page.dart';
import 'package:ice/app/features/user/pages/switch_account_page/switch_account_page.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/coin_details_page.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/coin_receive_modal.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/model/coin_receive_modal_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/network_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/share_address_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/receive_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/confirmation_sheet.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_result_sheet.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/contacts_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/network_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/send_coins_form.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/send_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/manage_coins_page.dart';
import 'package:ice/app/features/wallet/views/pages/nfts_sorting_modal/nfts_sorting_modal.dart';
import 'package:ice/app/features/wallet/views/pages/request_contacts_access_modal/request_contacts_access_modal.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/wallet_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_scan/wallet_scan_modal_page.dart';
import 'package:ice/app/features/wallets/pages/create_new_wallet_modal/create_new_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/delete_wallet_modal/delete_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/edit_wallet_modal/edit_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/manage_wallets_modal/manage_wallets_modal.dart';
import 'package:ice/app/features/wallets/pages/wallets_modal/wallets_modal.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/base_route.dart';
import 'package:ice/app/router/main_tab_navigation.dart';
import 'package:ice/app/services/logger/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sheet/sheet.dart';

part 'app_routes.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: [
    TypedStatefulShellBranch<FeedBranchData>(
      routes: [
        TypedGoRoute<FeedRoute>(path: '/feed'),
      ],
    ),
    TypedStatefulShellBranch<ChatBranchData>(
      routes: [
        TypedGoRoute<ChatRoute>(path: '/chat'),
      ],
    ),
    TypedStatefulShellBranch<DappsBranchData>(
      routes: [
        TypedGoRoute<DappsRoute>(path: '/dapps'),
      ],
    ),
    TypedStatefulShellBranch<WalletBranchData>(
      routes: [
        TypedGoRoute<WalletRoute>(
          path: '/wallet',
          routes: [
            TypedGoRoute<AllowAccessRoute>(path: 'allow-access'),
            TypedGoRoute<NftsSortingRoute>(path: 'nfts-sorting'),
            TypedGoRoute<CoinSendRoute>(path: 'coin-send'),
            TypedGoRoute<ReceiveCoinRoute>(path: 'receive-coin'),
            TypedGoRoute<ScanWalletRoute>(path: 'scan-wallet'),
            TypedGoRoute<NetworkSelectRoute>(path: 'network-select'),
            TypedGoRoute<NetworkSelectReceiveRoute>(
              path: 'network-select-receive',
            ),
            TypedGoRoute<ShareAddressRoute>(path: 'share-address'),
            TypedGoRoute<ContactsSelectRoute>(path: 'contacts-select'),
            TypedGoRoute<CoinsSendFormRoute>(path: 'coin-send-form'),
            TypedGoRoute<CoinsSendFormConfirmationRoute>(
              path: 'coin-send-form-confirmation',
            ),
            TypedGoRoute<TransactionResultRoute>(path: 'transaction-result'),
            TypedGoRoute<CoinsDetailsRoute>(path: 'coin-details'),
            TypedGoRoute<CoinReceiveRoute>(path: 'coin-receive'),
            TypedGoRoute<ManageCoinsRoute>(path: 'manage-coins'),
            TypedGoRoute<WalletsRoute>(path: 'wallets'),
            TypedGoRoute<ManageWalletsRoute>(path: 'manage-wallets'),
            TypedGoRoute<CreateWalletRoute>(path: 'create-wallet'),
            TypedGoRoute<EditWalletRoute>(path: 'edit-wallet'),
            TypedGoRoute<DeleteWalletRoute>(path: 'delete-wallet'),
          ],
        ),
      ],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  static final $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainTabNavigation(
      navigationShell: navigationShell,
    );
  }
}

class FeedBranchData extends StatefulShellBranchData {
  FeedBranchData();
}

class ChatBranchData extends StatefulShellBranchData {
  const ChatBranchData();
}

class WalletBranchData extends StatefulShellBranchData {
  const WalletBranchData();
}

class DappsBranchData extends StatefulShellBranchData {
  const DappsBranchData();
}

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends BaseRouteData {
  SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

class FeedRoute extends BaseRouteData {
  FeedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const FeedPage();
}

class ChatRoute extends BaseRouteData {
  ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ChatPage();
}

class WalletRoute extends BaseRouteData {
  WalletRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const WalletPage();
}

class DappsRoute extends BaseRouteData {
  DappsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const DAppsPage();
}

class ErrorRoute extends BaseRouteData {
  ErrorRoute({required this.error});

  final Exception error;

  @override
  Widget build(BuildContext context, GoRouterState state) => ErrorPage(
        error: error,
      );
}

class NotFoundRoute extends BaseRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NotFoundPage();
}

@TypedGoRoute<IntroRoute>(
  path: '/intro',
  routes: [
    TypedGoRoute<AuthRoute>(path: 'auth'),
    TypedGoRoute<SelectCountriesRoute>(path: 'select-countries'),
    TypedGoRoute<SelectLanguagesRoute>(path: 'select-languages'),
    TypedGoRoute<CheckEmailRoute>(path: 'check-email'),
    TypedGoRoute<FillProfileRoute>(path: 'fill-profile'),
    TypedGoRoute<DiscoverCreatorsRoute>(path: 'discover-creators'),
    TypedGoRoute<NostrAuthRoute>(path: 'nostr-auth'),
    TypedGoRoute<NostrLoginRoute>(path: 'nostr-login'),
    TypedGoRoute<EnterCodeRoute>(path: 'enter-code'),
  ],
)
class IntroRoute extends BaseRouteData {
  IntroRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

class AuthRoute extends BaseRouteData {
  AuthRoute() : super(transitionType: IceRouteType.bottomSheet);

  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthPage();
}

class SelectCountriesRoute extends BaseRouteData {
  SelectCountriesRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectCountries();
}

class SelectLanguagesRoute extends BaseRouteData {
  SelectLanguagesRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectLanguages();
}

class CheckEmailRoute extends BaseRouteData {
  CheckEmailRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const CheckEmail();
}

class FillProfileRoute extends BaseRouteData {
  FillProfileRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FillProfile();
}

class DiscoverCreatorsRoute extends BaseRouteData {
  DiscoverCreatorsRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DiscoverCreators();
}

class NostrAuthRoute extends BaseRouteData {
  NostrAuthRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const NostrAuth();
}

class NostrLoginRoute extends BaseRouteData {
  NostrLoginRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const NostrLogin();
}

class EnterCodeRoute extends BaseRouteData {
  EnterCodeRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const EnterCode();
}

@TypedGoRoute<FeedMainModal>(path: '/feed-modal')
class FeedMainModal extends BaseRouteData {
  FeedMainModal() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FeedMainModalPage();
}

@TypedGoRoute<DAppsRoute>(
  path: '/dapps',
  routes: [
    TypedGoRoute<DAppsListRoute>(path: 'apps-list'),
    TypedGoRoute<DAppDetailsRoute>(path: 'dapps-details'),
  ],
)
class DAppsRoute extends BaseRouteData {
  DAppsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const DAppsPage();
}

class DAppsListRoute extends BaseRouteData {
  DAppsListRoute({required this.$extra});

  final AppsRouteData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => DAppsList(
        payload: $extra,
      );
}

class DAppDetailsRoute extends BaseRouteData {
  DAppDetailsRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => DAppDetails();
}

@TypedGoRoute<PullRightMenuRoute>(
  path: '/pull-right-menu',
  routes: [
    TypedGoRoute<SwitchAccountRoute>(path: 'switch-account'),
  ],
)
class PullRightMenuRoute extends BaseRouteData {
  PullRightMenuRoute() : super(transitionType: IceRouteType.slideFromLeft);

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PullRightMenuPage();
}

class SwitchAccountRoute extends BaseRouteData {
  SwitchAccountRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SwitchAccountPage();
}

class AllowAccessRoute extends BaseRouteData {
  AllowAccessRoute()
      : super(
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RequestContactAccessModal();
}

class NftsSortingRoute extends BaseRouteData {
  NftsSortingRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NftsSortingModal();
}

class CoinSendRoute extends BaseRouteData {
  CoinSendRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SendCoinModalPage();
}

class ReceiveCoinRoute extends BaseRouteData {
  ReceiveCoinRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReceiveCoinModalPage();
}

class ScanWalletRoute extends BaseRouteData {
  ScanWalletRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WalletScanModalPage();
}

class NetworkSelectRoute extends BaseRouteData {
  NetworkSelectRoute()
      : super(
          transitionType: IceRouteType.bottomSheet,
          sheetFit: SheetFit.expand,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NetworkListView();
}

class NetworkSelectReceiveRoute extends BaseRouteData {
  NetworkSelectReceiveRoute({required this.$extra})
      : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  final CoinData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NetworkListReceiveView(payload: $extra);
}

class ShareAddressRoute extends BaseRouteData {
  ShareAddressRoute({required this.$extra})
      : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ShareAddressView(payload: $extra);
}

class ContactsSelectRoute extends BaseRouteData {
  ContactsSelectRoute({required this.$extra})
      : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  final ContactData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ContactsListView(payload: $extra);
}

class CoinsSendFormRoute extends BaseRouteData {
  CoinsSendFormRoute()
      : super(
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SendCoinsForm();
}

class CoinsSendFormConfirmationRoute extends BaseRouteData {
  CoinsSendFormConfirmationRoute()
      : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ConfirmationSheet();
}

class TransactionResultRoute extends BaseRouteData {
  TransactionResultRoute()
      : super(
          transitionType: IceRouteType.bottomSheet,
          // initialExtent: 0.7,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TransactionResultSheet();
}

class CoinsDetailsRoute extends BaseRouteData {
  CoinsDetailsRoute({required this.$extra});

  final CoinData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CoinDetailsPage(payload: $extra);
}

class CoinReceiveRoute extends BaseRouteData {
  CoinReceiveRoute({required this.$extra})
      : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  final CoinReceiveModalData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CoinReceiveModal(payload: $extra);
}

class ManageCoinsRoute extends BaseRouteData {
  ManageCoinsRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ManageCoinsPage();
}

class WalletsRoute extends BaseRouteData {
  WalletsRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WalletsModal();
}

class ManageWalletsRoute extends BaseRouteData {
  ManageWalletsRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ManageWalletsModal();
}

class CreateWalletRoute extends BaseRouteData {
  CreateWalletRoute() : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CreateNewWalletModal();
}

class EditWalletRoute extends BaseRouteData {
  EditWalletRoute({required this.$extra})
      : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  final WalletData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditWalletModal(payload: $extra);
}

class DeleteWalletRoute extends BaseRouteData {
  DeleteWalletRoute({required this.$extra})
      : super(transitionType: IceRouteType.bottomSheet);

  static final $parentNavigatorKey = rootNavigatorKey;

  final WalletData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DeleteWalletModal(payload: $extra);
}

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authState = ref.watch(authProvider);
  final initState = ref.watch(initAppProvider);
  final isAnimationCompleted = ref.watch(splashProvider);

  return GoRouter(
    refreshListenable: ref.read(appRouterListenableProvider.notifier),
    redirect: (context, state) {
      final isSplash = state.matchedLocation == SplashRoute().location;
      final isAuthenticated = authState is Authenticated;
      final isUnAuthenticated = authState is UnAuthenticated;
      final isAuthUnknown = authState is AuthenticationUnknown;
      final isAuthLoading = authState is AuthenticationLoading;
      final isInitInProgress = initState.isLoading;
      final isInitError = initState.hasError;
      final isInitCompleted = initState.hasValue;

      if (isInitError) {
        return '/error';
      }

      if (isInitInProgress && !isSplash) {
        return SplashRoute().location;
      }

      if (isInitCompleted && isSplash && isAnimationCompleted) {
        if (isAuthenticated) {
          return FeedRoute().location;
        }
        if (isUnAuthenticated) {
          return IntroRoute().location;
        }
      }

      if (isAuthLoading || isAuthUnknown) {
        return null;
      }

      // if (isUnAuthenticated && state.matchedLocation != '/intro') {
      //   return '/intro';
      // }

      if (isAuthenticated && state.matchedLocation == IntroRoute().location) {
        return FeedRoute().location;
      }

      return null;
    },
    routes: $appRoutes,
    errorBuilder: (context, state) =>
        ErrorRoute(error: state.error!).build(context, state),
    initialLocation: SplashRoute().location,
    debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
    navigatorKey: rootNavigatorKey,
  );
}
