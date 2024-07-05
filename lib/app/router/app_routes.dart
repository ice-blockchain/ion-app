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
import 'package:ice/app/router/components/modal_wrapper/modal_wrapper.dart';
import 'package:ice/app/router/main_tab_navigation.dart';
import 'package:ice/app/services/logger/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

part 'app_routes.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNavigator',
);
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellNavigator',
);
final GlobalKey<NavigatorState> modalNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'modalNavigator');

final transitionObserver = NavigationSheetTransitionObserver();

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: [
    TypedStatefulShellBranch<FeedBranchData>(
      routes: [TypedGoRoute<FeedRoute>(path: '/feed')],
    ),
    TypedStatefulShellBranch<ChatBranchData>(
      routes: [TypedGoRoute<ChatRoute>(path: '/chat')],
    ),
    TypedStatefulShellBranch<DappsBranchData>(
      routes: [TypedGoRoute<DappsRoute>(path: '/dapps')],
    ),
    TypedStatefulShellBranch<WalletBranchData>(
      routes: [
        TypedGoRoute<WalletRoute>(
          path: '/wallet',
          routes: [
            TypedGoRoute<AllowAccessRoute>(path: 'allow-access'),
            TypedGoRoute<NftsSortingRoute>(path: 'nfts-sorting'),
            TypedStatefulShellRoute<ModalShellRouteData>(
              branches: [
                TypedStatefulShellBranch<CoinSendBranchData>(
                  routes: [
                    TypedGoRoute<CoinSendRoute>(
                      path: 'coin-send',
                      routes: [
                        TypedGoRoute<NetworkSelectRoute>(
                          path: 'network-select',
                          routes: [
                            TypedGoRoute<CoinsSendFormRoute>(
                              path: 'coin-send-form',
                              routes: [
                                TypedGoRoute<CoinsSendFormConfirmationRoute>(
                                  path: 'coin-send-form-confirmation',
                                  routes: [
                                    TypedGoRoute<TransactionResultRoute>(
                                      path: 'transaction-result',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // TypedGoRoute<CoinSendRoute>(
            //   path: 'coin-send',
            //   routes: [
            //     TypedGoRoute<NetworkSelectRoute>(
            //       path: 'network-select',
            //       routes: [
            //         TypedGoRoute<CoinsSendFormRoute>(
            //           path: 'coin-send-form',
            //           routes: [
            //             TypedGoRoute<CoinsSendFormConfirmationRoute>(
            //               path: 'coin-send-form-confirmation',
            //               routes: [
            //                 TypedGoRoute<TransactionResultRoute>(
            //                   path: 'transaction-result',
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            TypedGoRoute<ReceiveCoinRoute>(path: 'receive-coin'),
            TypedGoRoute<ScanWalletRoute>(path: 'scan-wallet'),
            // TypedGoRoute<NetworkSelectRoute>(path: 'network-select'),
            TypedGoRoute<NetworkSelectReceiveRoute>(
              path: 'network-select-receive',
            ),
            TypedGoRoute<ShareAddressRoute>(path: 'share-address'),
            TypedGoRoute<ContactsSelectRoute>(path: 'contacts-select'),
            // TypedGoRoute<CoinsSendFormRoute>(path: 'coin-send-form'),
            // TypedGoRoute<CoinsSendFormConfirmationRoute>(
            //   path: 'coin-send-form-confirmation',
            // ),
            // TypedGoRoute<TransactionResultRoute>(path: 'transaction-result'),
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

class ModalShellRouteData extends StatefulShellRouteData {
  const ModalShellRouteData();

  static final $navigatorKey = modalNavigatorKey;
  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ModalSheetPage(
      swipeDismissible: true,
      child: ModalWrapper(
        child: navigationShell,
      ),
    );
  }
}

class CoinSendBranchData extends StatefulShellBranchData {
  const CoinSendBranchData();
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
  SplashRoute() : super(child: const SplashPage());
}

class FeedRoute extends BaseRouteData {
  FeedRoute() : super(child: const FeedPage());
}

class ChatRoute extends BaseRouteData {
  ChatRoute() : super(child: const ChatPage());
}

class WalletRoute extends BaseRouteData {
  WalletRoute() : super(child: const WalletPage());
}

class DappsRoute extends BaseRouteData {
  DappsRoute() : super(child: const DAppsPage());
}

@TypedGoRoute<ErrorRoute>(path: '/error')
class ErrorRoute extends BaseRouteData {
  ErrorRoute({required this.$extra})
      : super(child: ErrorPage(error: $extra ?? Exception('Unknown error')));

  final Exception? $extra;
}

class NotFoundRoute extends BaseRouteData {
  NotFoundRoute() : super(child: const NotFoundPage());
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
  IntroRoute() : super(child: const IntroPage());
}

class AuthRoute extends BaseRouteData {
  AuthRoute()
      : super(
          child: const AuthPage(),
          transitionType: IceRouteType.bottomSheet,
        );
}

class SelectCountriesRoute extends BaseRouteData {
  SelectCountriesRoute()
      : super(
          child: const SelectCountries(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class SelectLanguagesRoute extends BaseRouteData {
  SelectLanguagesRoute()
      : super(
          child: const SelectLanguages(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class CheckEmailRoute extends BaseRouteData {
  CheckEmailRoute()
      : super(
          child: const CheckEmail(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class FillProfileRoute extends BaseRouteData {
  FillProfileRoute()
      : super(
          child: const FillProfile(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class DiscoverCreatorsRoute extends BaseRouteData {
  DiscoverCreatorsRoute()
      : super(
          child: const DiscoverCreators(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class NostrAuthRoute extends BaseRouteData {
  NostrAuthRoute()
      : super(
          child: const NostrAuth(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class NostrLoginRoute extends BaseRouteData {
  NostrLoginRoute()
      : super(
          child: const NostrLogin(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class EnterCodeRoute extends BaseRouteData {
  EnterCodeRoute()
      : super(
          child: const EnterCode(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

@TypedGoRoute<FeedMainModal>(path: '/feed-modal')
class FeedMainModal extends BaseRouteData {
  FeedMainModal()
      : super(
          child: const FeedMainModalPage(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

@TypedGoRoute<DAppsRoute>(
  path: '/dapps',
  routes: [
    TypedGoRoute<DAppsListRoute>(path: 'apps-list'),
    TypedGoRoute<DAppDetailsRoute>(path: 'dapps-details'),
  ],
)
class DAppsRoute extends BaseRouteData {
  DAppsRoute() : super(child: const DAppsPage());
}

class DAppsListRoute extends BaseRouteData {
  DAppsListRoute({required this.$extra})
      : super(child: DAppsList(payload: $extra));

  final AppsRouteData $extra;
}

class DAppDetailsRoute extends BaseRouteData {
  DAppDetailsRoute()
      : super(
          child: DAppDetails(),
          transitionType: IceRouteType.bottomSheet,
        );
}

@TypedGoRoute<PullRightMenuRoute>(
  path: '/pull-right-menu',
  routes: [
    TypedGoRoute<SwitchAccountRoute>(path: 'switch-account'),
  ],
)
class PullRightMenuRoute extends BaseRouteData {
  PullRightMenuRoute()
      : super(
          child: const PullRightMenuPage(),
          transitionType: IceRouteType.slideFromLeft,
        );
}

class SwitchAccountRoute extends BaseRouteData {
  SwitchAccountRoute()
      : super(
          child: const SwitchAccountPage(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class AllowAccessRoute extends BaseRouteData {
  AllowAccessRoute()
      : super(
          child: const RequestContactAccessModal(),
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class NftsSortingRoute extends BaseRouteData {
  NftsSortingRoute()
      : super(
          child: const NftsSortingModal(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class CoinSendRoute extends BaseRouteData {
  CoinSendRoute()
      : super(
          child: const NotFoundPage(),
          transitionType: IceRouteType.bottomSheet,
        );
}

class ReceiveCoinRoute extends BaseRouteData {
  ReceiveCoinRoute()
      : super(
          child: const ReceiveCoinModalPage(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class ScanWalletRoute extends BaseRouteData {
  ScanWalletRoute()
      : super(
          child: const WalletScanModalPage(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class NetworkSelectRoute extends BaseRouteData {
  NetworkSelectRoute()
      : super(
          child: const NetworkListView(),
          transitionType: IceRouteType.bottomSheet,
        );
}

class NetworkSelectReceiveRoute extends BaseRouteData {
  NetworkSelectReceiveRoute({required this.$extra})
      : super(
          child: NetworkListReceiveView(payload: $extra),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  final CoinData $extra;
}

class ShareAddressRoute extends BaseRouteData {
  ShareAddressRoute({required this.$extra})
      : super(
          child: ShareAddressView(payload: $extra),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  final Map<String, dynamic> $extra;
}

class ContactsSelectRoute extends BaseRouteData {
  ContactsSelectRoute({required this.$extra})
      : super(
          child: ContactsListView(payload: $extra),
          transitionType: IceRouteType.bottomSheet,
        );

  final ContactData $extra;
}

class CoinsSendFormRoute extends BaseRouteData {
  CoinsSendFormRoute()
      : super(
          child: const SendCoinsForm(),
          transitionType: IceRouteType.bottomSheet,
        );
}

class CoinsSendFormConfirmationRoute extends BaseRouteData {
  CoinsSendFormConfirmationRoute()
      : super(
          child: const ConfirmationSheet(),
          transitionType: IceRouteType.bottomSheet,
        );
}

class TransactionResultRoute extends BaseRouteData {
  TransactionResultRoute()
      : super(
          child: const TransactionResultSheet(),
          transitionType: IceRouteType.bottomSheet,
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
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  final CoinReceiveModalData $extra;
}

class ManageCoinsRoute extends BaseRouteData {
  ManageCoinsRoute()
      : super(
          child: const ManageCoinsPage(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class WalletsRoute extends BaseRouteData {
  WalletsRoute()
      : super(
          child: const WalletsModal(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class ManageWalletsRoute extends BaseRouteData {
  ManageWalletsRoute()
      : super(
          child: const ManageWalletsModal(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class CreateWalletRoute extends BaseRouteData {
  CreateWalletRoute()
      : super(
          child: const CreateNewWalletModal(),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;
}

class EditWalletRoute extends BaseRouteData {
  EditWalletRoute({required this.$extra})
      : super(
          child: EditWalletModal(payload: $extra),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  final WalletData $extra;
}

class DeleteWalletRoute extends BaseRouteData {
  DeleteWalletRoute({required this.$extra})
      : super(
          child: DeleteWalletModal(payload: $extra),
          transitionType: IceRouteType.bottomSheet,
        );

  static final $parentNavigatorKey = rootNavigatorKey;

  final WalletData $extra;
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
        ErrorRoute($extra: state.error).build(context, state),
    initialLocation: SplashRoute().location,
    debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
    navigatorKey: rootNavigatorKey,
    observers: [transitionObserver],
  );
}
