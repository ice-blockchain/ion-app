import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/discover_creators.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/get_started/get_started.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/intro_page.dart';
import 'package:ice/app/features/auth/views/pages/restore_creds/restore_creds.dart';
import 'package:ice/app/features/auth/views/pages/restore_menu/restore_menu.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/select_languages.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_passkey/sign_up_passkey.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_password/sign_up_password.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/turn_on_notifications.dart';
import 'package:ice/app/features/auth/views/pages/twofa_codes/twofa_codes_page.dart';
import 'package:ice/app/features/auth/views/pages/twofa_options/twofa_options_page.dart';
import 'package:ice/app/features/chat/views/pages/chat_main_modal/chat_main_modal_page.dart';
import 'package:ice/app/features/chat/views/pages/chat_page/chat_page.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/pages/dapp_details/dapp_details.dart';
import 'package:ice/app/features/dapps/views/pages/dapps.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_list/dapps_list.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_main_modal/dapps_main_modal_page.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/feed_main_modal_page.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/feed_page.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/post_details_page.dart';
import 'package:ice/app/features/feed/views/pages/quote_post_modal_page/quote_post_modal_page.dart';
import 'package:ice/app/features/feed/views/pages/reply_expanded_page/reply_expanded_page.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/share_options_modal_page.dart';
import 'package:ice/app/features/feed/views/pages/share_type_modal_page/share_type_modal_page.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_page.dart';
import 'package:ice/app/features/user/pages/switch_account_page/switch_account_page.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/coin_details_page.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/coin_receive_modal.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/model/coin_receive_modal_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/network_list/network_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/share_address_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/receive_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/confirmation_sheet.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_result_sheet.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/contacts_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/send_coins_form.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/send_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/send_nft_form.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft_confirm/send_nft_confirm.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/transaction_details/transaction_details.dart';
import 'package:ice/app/features/wallet/views/pages/contact_modal_page/contact_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/manage_coins_page.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/nft_details_page.dart';
import 'package:ice/app/features/wallet/views/pages/nfts_sorting_modal/nfts_sorting_modal.dart';
import 'package:ice/app/features/wallet/views/pages/request_contacts_access_modal/request_contacts_access_modal.dart';
import 'package:ice/app/features/wallet/views/pages/send_nft/views/pages/nft_details/nft_details_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_main_modal/wallet_main_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/wallet_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_scan/wallet_scan_modal_page.dart';
import 'package:ice/app/features/wallets/pages/create_new_wallet_modal/create_new_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/delete_wallet_modal/delete_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/edit_wallet_modal/edit_wallet_modal.dart';
import 'package:ice/app/features/wallets/pages/manage_wallets_modal/manage_wallets_modal.dart';
import 'package:ice/app/features/wallets/pages/wallets_modal/wallets_modal.dart';
import 'package:ice/app/router/base_route_data.dart';
import 'package:ice/app/router/components/modal_wrapper/modal_wrapper.dart';
import 'package:ice/app/router/main_tabs/main_tab_navigation.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

part 'app_routes.g.dart';
part 'auth_routes.dart';
part 'wallet_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
final bottomBarNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'tabNav');
final transitionObserver = NavigationSheetTransitionObserver();

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<FeedRoute>(
          path: '/feed',
          routes: [
            TypedGoRoute<PostDetailsRoute>(
              path: 'post',
              routes: [
                TypedShellRoute<ModalShellRouteData>(
                  routes: [
                    TypedGoRoute<ReplyExpandedRoute>(path: 'reply-modal'),
                  ],
                ),
              ],
            ),
            TypedGoRoute<FeedMainModalRoute>(path: 'main-modal'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<ChatRoute>(
          path: '/chat',
          routes: [
            TypedGoRoute<ChatMainModalRoute>(path: 'main-modal'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<DappsRoute>(
          path: '/dapps',
          routes: [
            TypedGoRoute<DappsMainModalRoute>(path: 'main-modal'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<WalletRoute>(
          path: '/wallet',
          routes: [
            ...WalletRoutes.routes,
            TypedGoRoute<WalletMainModalRoute>(path: 'main-modal'),
          ],
        ),
      ],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  static final $navigatorKey = bottomBarNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainTabNavigation(
      shell: navigationShell,
      state: state,
    );
  }
}

class ModalShellRouteData extends ShellRouteData {
  const ModalShellRouteData();

  static final $parentNavigatorKey = rootNavigatorKey;
  static final $observers = <NavigatorObserver>[transitionObserver];

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return ModalSheetPage(
      swipeDismissible: true,
      child: ModalWrapper(child: navigator),
    );
  }
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
  ErrorRoute({this.$extra}) : super(child: ErrorPage(error: $extra ?? Exception('Unknown error')));

  final Exception? $extra;
}

@TypedGoRoute<IntroRoute>(
  path: '/intro',
  routes: [...AuthRoutes.routes],
)
class IntroRoute extends BaseRouteData {
  IntroRoute() : super(child: const IntroPage());
}

class FeedMainModalRoute extends BaseRouteData {
  FeedMainModalRoute()
      : super(
          child: const FeedMainModalPage(),
          type: IceRouteType.mainModalSheet,
        );
}

class ChatMainModalRoute extends BaseRouteData {
  ChatMainModalRoute()
      : super(
          child: const ChatMainModalPage(),
          type: IceRouteType.mainModalSheet,
        );
}

class DappsMainModalRoute extends BaseRouteData {
  DappsMainModalRoute()
      : super(
          child: const DappsMainModalPage(),
          type: IceRouteType.mainModalSheet,
        );
}

class WalletMainModalRoute extends BaseRouteData {
  WalletMainModalRoute()
      : super(
          child: const WalletMainModalPage(),
          type: IceRouteType.mainModalSheet,
        );
}

@TypedGoRoute<DAppsRoute>(
  path: '/dapps',
  routes: [
    TypedGoRoute<DAppsListRoute>(path: 'apps-list'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<DAppDetailsRoute>(path: 'dapps-details'),
      ],
    ),
  ],
)
class DAppsRoute extends BaseRouteData {
  DAppsRoute() : super(child: const DAppsPage());
}

class DAppsListRoute extends BaseRouteData {
  DAppsListRoute({required this.$extra}) : super(child: DAppsList(payload: $extra));

  final AppsRouteData $extra;
}

class DAppDetailsRoute extends BaseRouteData {
  DAppDetailsRoute()
      : super(
          child: DAppDetails(),
          type: IceRouteType.bottomSheet,
        );
}

@TypedGoRoute<PullRightMenuRoute>(
  path: '/pull-right-menu',
  routes: [
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<SwitchAccountRoute>(path: 'switch-account'),
      ],
    ),
  ],
)
class PullRightMenuRoute extends BaseRouteData {
  PullRightMenuRoute()
      : super(
          child: const PullRightMenuPage(),
          type: IceRouteType.slideFromLeft,
        );
}

class SwitchAccountRoute extends BaseRouteData {
  SwitchAccountRoute()
      : super(
          child: const SwitchAccountPage(),
          type: IceRouteType.bottomSheet,
        );
}

class PostDetailsRoute extends BaseRouteData {
  PostDetailsRoute({required this.$extra})
      : super(
          child: PostDetailsPage(
            postId: $extra,
          ),
        );

  final String $extra;
}

class ReplyExpandedRoute extends BaseRouteData {
  ReplyExpandedRoute({
    required this.$extra,
  }) : super(
          type: IceRouteType.bottomSheet,
          child: ReplyExpandedPage(
            postId: $extra,
          ),
        );

  final String $extra;
}
