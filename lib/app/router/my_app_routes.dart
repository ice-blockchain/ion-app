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
import 'package:ice/app/router/my_app_router_listenable.dart';
import 'package:ice/app/router/my_main_tab_navigation.dart';
import 'package:ice/app/services/logger/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_app_routes.g.dart';

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
    TypedStatefulShellBranch<DappsBranchData>(
      routes: [
        TypedGoRoute<DappsRoute>(path: '/dapps'),
      ],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainTabNavigation(navigationShell: navigationShell);
  }
}

class FeedBranchData extends StatefulShellBranchData {
  const FeedBranchData();
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
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

class FeedRoute extends GoRouteData {
  const FeedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const FeedPage();
}

class ChatRoute extends GoRouteData {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ChatPage();
}

class WalletRoute extends GoRouteData {
  const WalletRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const WalletPage();
}

class DappsRoute extends GoRouteData {
  const DappsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const DAppsPage();
}

// @TypedGoRoute<ErrorRoute>(path: '/error')
class ErrorRoute extends GoRouteData {
  ErrorRoute({required this.error});

  final Exception error;

  @override
  Widget build(BuildContext context, GoRouterState state) => ErrorPage(
        error: error,
      );
}

class NotFoundRoute extends GoRouteData {
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
class IntroRoute extends GoRouteData {
  const IntroRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

class AuthRoute extends GoRouteData {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthPage();
}

class SelectCountriesRoute extends GoRouteData {
  const SelectCountriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectCountries();
}

class SelectLanguagesRoute extends GoRouteData {
  const SelectLanguagesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectLanguages();
}

class CheckEmailRoute extends GoRouteData {
  const CheckEmailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const CheckEmail();
}

class FillProfileRoute extends GoRouteData {
  const FillProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FillProfile();
}

class DiscoverCreatorsRoute extends GoRouteData {
  const DiscoverCreatorsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DiscoverCreators();
}

class NostrAuthRoute extends GoRouteData {
  const NostrAuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NostrAuth();
}

class NostrLoginRoute extends GoRouteData {
  const NostrLoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NostrLogin();
}

class EnterCodeRoute extends GoRouteData {
  const EnterCodeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const EnterCode();
}

@TypedGoRoute<FeedMainModal>(path: '/feed-modal')
class FeedMainModal extends GoRouteData {
  const FeedMainModal();

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
class DAppsRoute extends GoRouteData {
  const DAppsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const DAppsPage();
}

class DAppsListRoute extends GoRouteData {
  const DAppsListRoute({required this.$extra});

  final AppsRouteData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => DAppsList(
        payload: $extra,
      );
}

class DAppDetailsRoute extends GoRouteData {
  const DAppDetailsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => DAppDetails();
}

@TypedGoRoute<PullRightMenuRoute>(
  path: '/pull-right-menu',
  routes: [
    TypedGoRoute<SwitchAccountRoute>(path: 'switch-account'),
  ],
)
class PullRightMenuRoute extends GoRouteData {
  const PullRightMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PullRightMenuPage();
}

class SwitchAccountRoute extends GoRouteData {
  const SwitchAccountRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SwitchAccountPage();
}

class AllowAccessRoute extends GoRouteData {
  const AllowAccessRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RequestContactAccessModal();
}

class NftsSortingRoute extends GoRouteData {
  const NftsSortingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NftsSortingModal();
}

class CoinSendRoute extends GoRouteData {
  const CoinSendRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SendCoinModalPage();
}

class ReceiveCoinRoute extends GoRouteData {
  const ReceiveCoinRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReceiveCoinModalPage();
}

class ScanWalletRoute extends GoRouteData {
  const ScanWalletRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WalletScanModalPage();
}

class NetworkSelectRoute extends GoRouteData {
  const NetworkSelectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NetworkListView();
}

class NetworkSelectReceiveRoute extends GoRouteData {
  const NetworkSelectReceiveRoute({required this.$extra});

  final CoinData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NetworkListReceiveView(payload: $extra);
}

class ShareAddressRoute extends GoRouteData {
  const ShareAddressRoute({required this.$extra});

  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ShareAddressView(payload: $extra);
}

class ContactsSelectRoute extends GoRouteData {
  const ContactsSelectRoute({required this.$extra});

  final ContactData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ContactsListView(payload: $extra);
}

class CoinsSendFormRoute extends GoRouteData {
  const CoinsSendFormRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SendCoinsForm();
}

class CoinsSendFormConfirmationRoute extends GoRouteData {
  const CoinsSendFormConfirmationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ConfirmationSheet();
}

class TransactionResultRoute extends GoRouteData {
  const TransactionResultRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TransactionResultSheet();
}

class CoinsDetailsRoute extends GoRouteData {
  const CoinsDetailsRoute({required this.$extra});

  final CoinData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CoinDetailsPage(payload: $extra);
}

class CoinReceiveRoute extends GoRouteData {
  const CoinReceiveRoute({required this.$extra});

  final CoinReceiveModalData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CoinReceiveModal(payload: $extra);
}

class ManageCoinsRoute extends GoRouteData {
  const ManageCoinsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ManageCoinsPage();
}

class WalletsRoute extends GoRouteData {
  const WalletsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WalletsModal();
}

class ManageWalletsRoute extends GoRouteData {
  const ManageWalletsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ManageWalletsModal();
}

class CreateWalletRoute extends GoRouteData {
  const CreateWalletRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CreateNewWalletModal();
}

class EditWalletRoute extends GoRouteData {
  const EditWalletRoute({required this.$extra});

  final WalletData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EditWalletModal(payload: $extra);
}

class DeleteWalletRoute extends GoRouteData {
  const DeleteWalletRoute({required this.$extra});

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
    refreshListenable: ref.read(myAppRouterListenableProvider.notifier),
    redirect: (context, state) {
      final isSplash = state.matchedLocation == const SplashRoute().location;
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
        return const SplashRoute().location;
      }

      if (isInitCompleted && isSplash && isAnimationCompleted) {
        if (isAuthenticated) {
          return const FeedRoute().location;
        }
        if (isUnAuthenticated) {
          return const IntroRoute().location;
        }
      }

      if (isAuthLoading || isAuthUnknown) {
        return null;
      }

      // if (isUnAuthenticated && state.matchedLocation != '/intro') {
      //   return '/intro';
      // }

      if (isAuthenticated &&
          state.matchedLocation == const IntroRoute().location) {
        return const FeedRoute().location;
      }

      return null;
    },
    routes: $appRoutes,
    errorBuilder: (context, state) =>
        ErrorRoute(error: state.error!).build(context, state),
    initialLocation: const SplashRoute().location,
    debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
  );
}
