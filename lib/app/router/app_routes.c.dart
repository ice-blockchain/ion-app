// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/pages/discover_creators/discover_creators.dart';
import 'package:ion/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ion/app/features/auth/views/pages/get_started/get_started.dart';
import 'package:ion/app/features/auth/views/pages/intro_page/intro_page.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/recover_user_page.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_page/recover_user_success_page.dart';
import 'package:ion/app/features/auth/views/pages/restore_creds/restore_creds.dart';
import 'package:ion/app/features/auth/views/pages/restore_menu/restore_menu.dart';
import 'package:ion/app/features/auth/views/pages/select_languages/select_languages.dart';
import 'package:ion/app/features/auth/views/pages/sign_up_passkey/sign_up_passkey.dart';
import 'package:ion/app/features/auth/views/pages/sign_up_password/sign_up_password.dart';
import 'package:ion/app/features/auth/views/pages/turn_on_notifications/turn_on_notifications.dart';
import 'package:ion/app/features/chat/messages/views/pages/messages_page.dart';
import 'package:ion/app/features/chat/model/conversation_data.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/pages/delete_conversation_modal/delete_conversation_modal.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/channel_page.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/edit_channel_page.dart';
import 'package:ion/app/features/chat/views/pages/chat_add_poll_modal/chat_add_poll_modal.dart';
import 'package:ion/app/features/chat/views/pages/chat_learn_more_modal/chat_learn_more_modal.dart';
import 'package:ion/app/features/chat/views/pages/chat_main_modal/chat_main_modal_page.dart';
import 'package:ion/app/features/chat/views/pages/chat_main_page/chat_main_page.dart';
import 'package:ion/app/features/chat/views/pages/group_page/group_page.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/new_channel_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_chat_modal/new_chat_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_group_modal/pages/add_group_participants_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_group_modal/pages/create_group_modal.dart';
import 'package:ion/app/features/chat/views/pages/share_profile_modal/share_profile_modal.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:ion/app/features/core/views/pages/app_test_page/app_test_page.dart';
import 'package:ion/app/features/core/views/pages/error_page.dart';
import 'package:ion/app/features/core/views/pages/search_emoji_modal/search_emoji_modal.dart';
import 'package:ion/app/features/core/views/pages/splash_page.dart';
import 'package:ion/app/features/core/views/photo_gallery_page/photo_gallery_page.dart';
import 'package:ion/app/features/dapps/views/pages/dapp_details/dapp_details_modal.dart';
import 'package:ion/app/features/dapps/views/pages/dapps.dart';
import 'package:ion/app/features/dapps/views/pages/dapps_list/dapps_list.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_modal/create_article_modal.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/create_article_topics.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/create_article_preview_modal.dart';
import 'package:ion/app/features/feed/create_post/views/pages/compress_test_page.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/create_post_modal.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/share/story_share_modal.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_preview_page.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_record_page.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_viewer_page.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/article_details_page.dart';
import 'package:ion/app/features/feed/views/pages/feed_main_modal/feed_main_modal_page.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/feed_page.dart';
import 'package:ion/app/features/feed/views/pages/notifications_history_page/notifications_history_page.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/post_details_page.dart';
import 'package:ion/app/features/feed/views/pages/repost_options_modal/repost_options_modal.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/share_post_modal.dart';
import 'package:ion/app/features/gallery/views/pages/album_selection_page.dart';
import 'package:ion/app/features/gallery/views/pages/gallery_camera_page.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_page.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/authenticator_delete_page.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/authenticator_delete_success.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/setup_authenticator/step_pages.dart';
import 'package:ion/app/features/protect_account/backup/views/components/errors/secure_account_error_alert.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/backup_options_page.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/backup_recovery_keys_modal.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/create_recover_key_page/create_recovery_key_page.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/recovery_keys_success_page.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/validate_recovery_key_page.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/email_delete_page.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/email_delete_success.dart';
import 'package:ion/app/features/protect_account/email/views/pages/setup_email/email_setup_page.dart';
import 'package:ion/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ion/app/features/protect_account/phone/views/components/countries/select_country_page.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/delete_phone/phone_delete_page.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/delete_phone/phone_delete_success.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/setup_phone/phone_setup_page.dart';
import 'package:ion/app/features/protect_account/secure_account/views/pages/secure_account_modal.dart';
import 'package:ion/app/features/protect_account/secure_account/views/pages/secure_account_options_page.dart';
import 'package:ion/app/features/search/views/pages/chat_advanced_search_page/chat_advanced_search_page.dart';
import 'package:ion/app/features/search/views/pages/chat_simple_search_page/chat_simple_search_page.dart';
import 'package:ion/app/features/search/views/pages/dapps_simple_search_page/dapps_simple_search_page.dart';
import 'package:ion/app/features/search/views/pages/feed_advanced_search_page/feed_advanced_search_page.dart';
import 'package:ion/app/features/search/views/pages/feed_search_filters_page/feed_search_filters_page.dart';
import 'package:ion/app/features/search/views/pages/feed_search_languages_page/feed_search_languages_page.dart';
import 'package:ion/app/features/search/views/pages/feed_simple_search_page/feed_simple_search_page.dart';
import 'package:ion/app/features/settings/views/app_language_modal.dart';
import 'package:ion/app/features/settings/views/content_language_modal.dart';
import 'package:ion/app/features/settings/views/logout_confirm_modal.dart';
import 'package:ion/app/features/settings/views/privacy_settings_modal.dart';
import 'package:ion/app/features/settings/views/profile_settings_modal.dart';
import 'package:ion/app/features/settings/views/push_notifications_settings.dart';
import 'package:ion/app/features/settings/views/settings_modal.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/model/user_category_type.dart';
import 'package:ion/app/features/user/pages/profile_edit_page/pages/category_select_modal/category_select_modal.dart';
import 'package:ion/app/features/user/pages/profile_edit_page/profile_edit_page.dart';
import 'package:ion/app/features/user/pages/profile_main_modal/profile_main_modal_page.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/follow_list_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/payment_selection_modal/payment_selection_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/request_coins_form_modal/request_coins_form_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_coin_modal/select_coin_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_network_modal/select_network_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/send_coins_form_modal/send_coin_form_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/profile_page.dart';
import 'package:ion/app/features/user/pages/profile_page/self_profile_page.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/pull_right_menu_page.dart';
import 'package:ion/app/features/user/pages/switch_account_modal/switch_account_modal.dart';
import 'package:ion/app/features/video/views/pages/videos_page.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/model/nft_data.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/coin_details/coin_details_page.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/coin_receive_modal/coin_receive_modal.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/network_list/network_list_view.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/receive_coins/components/share_address_view.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/receive_coins/receive_coin_modal_page.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/confirmation_sheet.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/confirmation/transaction_result_sheet.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/send_coins_form.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/send_coin_modal_page.dart';
import 'package:ion/app/features/wallet/views/pages/contact_modal_page/contact_modal_page.dart';
import 'package:ion/app/features/wallet/views/pages/friends_modal/friends_modal.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/manage_coins_page.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/manage_nfts_page.dart';
import 'package:ion/app/features/wallet/views/pages/nft_details/nft_details_page.dart';
import 'package:ion/app/features/wallet/views/pages/request_contacts_access_modal/request_contacts_access_modal.dart';
import 'package:ion/app/features/wallet/views/pages/send_nft_confirm/send_nft_confirm.dart';
import 'package:ion/app/features/wallet/views/pages/send_nft_form/send_nft_form.dart';
import 'package:ion/app/features/wallet/views/pages/transaction_details/explore_transaction_details_modal.dart';
import 'package:ion/app/features/wallet/views/pages/transaction_details/transaction_details.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_main_modal/wallet_main_modal_page.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/wallet_page.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_scan/wallet_scan_modal_page.dart';
import 'package:ion/app/features/wallets/pages/create_new_wallet_modal/create_new_wallet_modal.dart';
import 'package:ion/app/features/wallets/pages/delete_wallet_modal/delete_wallet_modal.dart';
import 'package:ion/app/features/wallets/pages/edit_wallet_modal/edit_wallet_modal.dart';
import 'package:ion/app/features/wallets/pages/manage_wallets_modal/manage_wallets_modal.dart';
import 'package:ion/app/features/wallets/pages/wallets_modal/wallets_modal.dart';
import 'package:ion/app/router/base_route_data.dart';
import 'package:ion/app/router/components/modal_wrapper/modal_wrapper.dart';
import 'package:ion/app/router/main_tabs/main_tab_navigation.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

part 'app_routes.c.g.dart';
part 'auth_routes.dart';
part 'channel_routes.dart';
part 'chat_routes.dart';
part 'dapps_routes.dart';
part 'feed_routes.dart';
part 'profile_routes.dart';
part 'protect_account_routes.dart';
part 'settings_routes.dart';
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
            ...ChatRoutes.routes,
            TypedGoRoute<ChatMainModalRoute>(path: 'main-modal'),
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
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<SelfProfileRoute>(
          path: '/self-profile',
          routes: [
            ...ProfileRoutes.routes,
            TypedGoRoute<ProfileMainModalRoute>(path: 'main-modal'),
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
      transitionCurve: Easing.standardDecelerate,
      swipeDismissible: true,
      swipeDismissSensitivity: SwipeDismissSensitivity(
        minFlingVelocityRatio: 3,
        minDragDistance: 300.0.s,
      ),
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
  ChatRoute() : super(child: const ChatMainPage());
}

class WalletRoute extends BaseRouteData {
  WalletRoute() : super(child: const WalletPage());
}

class SelfProfileRoute extends BaseRouteData {
  SelfProfileRoute() : super(child: const SelfProfilePage());
}

@TypedGoRoute<ErrorRoute>(path: '/error')
class ErrorRoute extends BaseRouteData {
  ErrorRoute({this.$extra})
      : super(
          child: ErrorPage(
            error: $extra ?? Exception('Unknown error'),
          ),
        );

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

class ProfileMainModalRoute extends BaseRouteData {
  ProfileMainModalRoute()
      : super(
          child: const ProfileMainModalPage(),
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

@TypedGoRoute<MessagesRoute>(
  path: '/messages',
  routes: [],
)
class MessagesRoute extends BaseRouteData {
  MessagesRoute(this.$extra)
      : super(
          child: MessagesPage($extra),
          type: IceRouteType.fade,
        );

  final ConversationData $extra;
}

@TypedGoRoute<CompressTestRoute>(path: '/compress-test')
class CompressTestRoute extends BaseRouteData {
  CompressTestRoute() : super(child: const CompressTestPage());
}

@TypedGoRoute<PhotoGalleryRoute>(path: '/photo-gallery')
class PhotoGalleryRoute extends BaseRouteData {
  PhotoGalleryRoute({
    required this.title,
    required this.senderName,
    required this.sentAt,
    this.photoUrls = const [],
  }) : super(
          child: PhotoGalleryPage(
            photoUrls: photoUrls,
            title: title,
            senderName: senderName,
            sentAt: sentAt,
          ),
          type: IceRouteType.fade,
        );

  final List<String> photoUrls;
  final String title;
  final String senderName;
  final DateTime sentAt;
}

class SearchEmojiRoute extends BaseRouteData {
  SearchEmojiRoute()
      : super(
          child: const SearchEmojiModal(),
          type: IceRouteType.bottomSheet,
        );
}
