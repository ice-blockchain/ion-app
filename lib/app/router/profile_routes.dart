// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.dart';

class ProfileRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<ProfileEditRoute>(path: 'profile_edit'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<FollowListRoute>(path: 'follow-list'),
        TypedGoRoute<CategorySelectRoute>(path: 'category-selector'),
        TypedGoRoute<BannerPickerRoute>(path: 'pick-banner'),
      ],
    ),
  ];
}

class ProfileEditRoute extends BaseRouteData {
  ProfileEditRoute({required this.pubkey})
      : super(
          child: ProfileEditPage(pubkey: pubkey),
        );

  final String pubkey;
}

class BannerPickerRoute extends BaseRouteData {
  BannerPickerRoute({required this.pubkey})
      : super(
          child: const MediaPickerPage(
            maxSelection: 1,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String pubkey;
}

class FollowListRoute extends BaseRouteData {
  FollowListRoute({
    required this.followType,
    required this.pubkey,
  }) : super(
          child: FollowListView(
            followType: followType,
            pubkey: pubkey,
          ),
          type: IceRouteType.bottomSheet,
        );

  final FollowType followType;
  final String pubkey;
}

class CategorySelectRoute extends BaseRouteData {
  CategorySelectRoute({
    required this.selectedUserCategoryType,
    required this.pubkey,
  }) : super(
          child: CategorySelectModal(
            selectedUserCategoryType: selectedUserCategoryType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final UserCategoryType? selectedUserCategoryType;
  final String pubkey;
}
