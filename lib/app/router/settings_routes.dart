// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class SettingsRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<SettingsRoute>(path: 'settings'),
    TypedGoRoute<ProfileSettingsRoute>(path: 'profile-settings'),
    TypedGoRoute<PrivacySettingsRoute>(path: 'privacy-settings'),
    TypedGoRoute<PushNotificationsSettingsRoute>(path: 'push-notifications-settings'),
    TypedGoRoute<AppLanguagesRoute>(path: 'app-language'),
    TypedGoRoute<ContentLanguagesRoute>(path: 'content-language'),
    TypedGoRoute<ConfirmLogoutRoute>(path: 'confirm-logout'),
    ...ProtectAccountRoutes.routes,
  ];
}

class SettingsRoute extends BaseRouteData {
  SettingsRoute()
      : super(
          child: const SettingsModal(),
          type: IceRouteType.bottomSheet,
        );
}

class AppLanguagesRoute extends BaseRouteData {
  AppLanguagesRoute()
      : super(
          child: const AppLanguageModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ContentLanguagesRoute extends BaseRouteData {
  ContentLanguagesRoute()
      : super(
          child: const ContentLanguageModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ProfileSettingsRoute extends BaseRouteData {
  ProfileSettingsRoute()
      : super(
          child: const ProfileSettingsModal(),
          type: IceRouteType.bottomSheet,
        );
}

class PrivacySettingsRoute extends BaseRouteData {
  PrivacySettingsRoute()
      : super(
          child: const PrivacySettingsModal(),
          type: IceRouteType.bottomSheet,
        );
}

class PushNotificationsSettingsRoute extends BaseRouteData {
  PushNotificationsSettingsRoute()
      : super(
          child: const PushNotificationsSettings(),
          type: IceRouteType.bottomSheet,
        );
}

class ConfirmLogoutRoute extends BaseRouteData {
  ConfirmLogoutRoute({required this.pubkey})
      : super(
          child: ConfirmLogoutModal(pubkey: pubkey),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
}
