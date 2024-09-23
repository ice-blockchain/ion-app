import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/discover_creators.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/get_started/get_started.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/intro_page.dart';
import 'package:ice/app/features/auth/views/pages/restore_creds/restore_creds.dart';
import 'package:ice/app/features/auth/views/pages/restore_menu/restore_menu.dart';
import 'package:ice/app/features/auth/views/pages/restore_recovery_keys/restore_recovery_keys_page.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/select_languages.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_passkey/sign_up_passkey.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_password/sign_up_password.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/turn_on_notifications.dart';
import 'package:ice/app/features/auth/views/pages/twofa_codes/twofa_codes_page.dart';
import 'package:ice/app/features/auth/views/pages/twofa_options/twofa_options_page.dart';
import 'package:ice/app/features/auth/views/pages/twofa_success/twofa_success_page.dart';
import 'package:ice/app/features/gallery/views/pages/image_picker_page.dart';
import 'package:ice/app/features/chat/views/pages/chat_main_modal/chat_main_modal_page.dart';
import 'package:ice/app/features/chat/views/pages/chat_page/chat_page.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/pages/dapp_details/dapp_details_modal.dart';
import 'package:ice/app/features/dapps/views/pages/dapps.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_list/dapps_list.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_main_modal/dapps_main_modal_page.dart';
import 'package:ice/app/features/feed/create_article/views/pages/create_article_modal/create_article_modal.dart';
import 'package:ice/app/features/feed/create_post/views/pages/create_post_modal/create_post_modal.dart';
import 'package:ice/app/features/feed/create_story/views/pages/create_story_modal/create_story_modal.dart';
import 'package:ice/app/features/feed/create_video/views/pages/create_video_modal/create_video_modal.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_advanced_search_page/feed_advanced_search_page.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/feed_simple_search_page.dart';
import 'package:ice/app/features/feed/views/pages/comment_post_modal/comment_post_modal.dart';
import 'package:ice/app/features/feed/views/pages/feed_main_modal/feed_main_modal_page.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/feed_page.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/post_details_page.dart';
import 'package:ice/app/features/feed/views/pages/post_reply_modal/post_reply_modal.dart';
import 'package:ice/app/features/feed/views/pages/repost_options_modal/repost_options_modal.dart';
import 'package:ice/app/features/feed/views/pages/share_post_modal/share_post_modal.dart';
import 'package:ice/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ice/app/features/protect_account/authenticator/views/pages/delete_authenticator/authenticator_delete_page.dart';
import 'package:ice/app/features/protect_account/authenticator/views/pages/delete_authenticator/authenticator_delete_success.dart';
import 'package:ice/app/features/protect_account/authenticator/views/pages/delete_authenticator/authenticator_initial_delete_page.dart';
import 'package:ice/app/features/protect_account/authenticator/views/pages/setup_authenticator/authenticator_setup_page.dart';
import 'package:ice/app/features/protect_account/backup/views/components/errors/recovery_keys_error_alert.dart';
import 'package:ice/app/features/protect_account/backup/views/components/errors/screenshot_security_alert.dart';
import 'package:ice/app/features/protect_account/backup/views/components/errors/secure_account_error_alert.dart';
import 'package:ice/app/features/protect_account/backup/views/pages/backup_options_page.dart';
import 'package:ice/app/features/protect_account/backup/views/pages/backup_recovery_keys_modal.dart';
import 'package:ice/app/features/protect_account/backup/views/pages/recovery_keys_input_page.dart';
import 'package:ice/app/features/protect_account/backup/views/pages/recovery_keys_save_page.dart';
import 'package:ice/app/features/protect_account/backup/views/pages/recovery_keys_success_page.dart';
import 'package:ice/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ice/app/features/protect_account/email/views/pages/setup_email/email_setup_page.dart';
import 'package:ice/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ice/app/features/protect_account/phone/views/components/countries/select_country_page.dart';
import 'package:ice/app/features/protect_account/phone/views/pages/setup_phone/phone_setup_page.dart';
import 'package:ice/app/features/protect_account/secure_account/views/pages/secure_account_modal.dart';
import 'package:ice/app/features/protect_account/secure_account/views/pages/secure_account_options_page.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_page.dart';
import 'package:ice/app/features/user/pages/switch_account_modal/switch_account_modal.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/coin_details_page.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/coin_receive_modal.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/model/coin_receive_modal_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/network_list/network_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/share_address_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/receive_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/confirmation_sheet.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_result_sheet.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/contacts_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/send_coins_form.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/send_coin_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/contact_modal_page/contact_modal_page.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/manage_coins_page.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/nft_details_page.dart';
import 'package:ice/app/features/wallet/views/pages/nfts_sorting_modal/nfts_sorting_modal.dart';
import 'package:ice/app/features/wallet/views/pages/request_contacts_access_modal/request_contacts_access_modal.dart';
import 'package:ice/app/features/wallet/views/pages/send_nft_confirm/send_nft_confirm.dart';
import 'package:ice/app/features/wallet/views/pages/send_nft_form/send_nft_form.dart';
import 'package:ice/app/features/wallet/views/pages/transaction_details/transaction_details.dart';
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
part 'feed_routes.dart';
part 'protect_account_routes.dart';
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
            ...FeedRoutes.routes,
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
      key: state.pageKey,
      shell: navigationShell,
      state: state,
    );
  }
}

@TypedShellRoute<ModalShellRouteData>(
  routes: [
    ...ProtectAccountRoutes.routes,
  ],
)
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
      key: state.pageKey,
      child: ModalWrapper(child: navigator),
      barrierColor: context.theme.appColors.backgroundSheet,
      transitionDuration: Duration(milliseconds: 300),
      transitionCurve: Easing.standardDecelerate,
      swipeDismissible: true,
      swipeDismissSensitivity:
          SwipeDismissSensitivity(minFlingVelocityRatio: 3.0, minDragDistance: 300.0.s),
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
  DAppDetailsRoute({required this.dappId})
      : super(
          child: DAppDetailsModal(dappId: dappId),
          type: IceRouteType.bottomSheet,
        );
  final int dappId;
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
          child: const SwitchAccountModal(),
          type: IceRouteType.bottomSheet,
        );
}
