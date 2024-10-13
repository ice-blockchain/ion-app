// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/providers/login_action_notifier.dart';
import 'package:ice/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/creator_list_item.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/providers/permissions_provider.dart';
import 'package:ice/app/features/user/providers/user_following_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class DiscoverCreators extends ConsumerWidget {
  const DiscoverCreators({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginActionState = ref.watch(loginActionNotifierProvider);
    final currentUserId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final followingIds = ref.watch(userFollowingProvider(currentUserId));
    final creatorIds = [
      'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
      '52d119f46298a8f7b08183b96d4e7ab54d6df0853303ad4a3c3941020f286129',
      '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
      '85035261ecddaf490e3fff9b9dc63cde7a9fb3243ba6bd1c4d89b372a457b1c1',
    ];

    final hasNotificationsPermission = ref.watch(hasPermissionProvider(Permission.notifications));

    final mayContinue = followingIds.valueOrNull?.isNotEmpty ?? false;

    return SheetContent(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.0.s),
            child: AuthHeader(
              title: context.i18n.discover_creators_title,
              description: context.i18n.discover_creators_description,
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList.separated(
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: 8.0.s,
                  ),
                  itemCount: creatorIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CreatorListItem(userId: creatorIds[index]);
                  },
                ),
                // TODO add ScreenBottomOffset.sliver factory for this case
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s + (mayContinue ? 0 : MediaQuery.paddingOf(context).bottom),
                  ),
                ),
              ],
            ),
          ),
          if (mayContinue)
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8.0.s,
                  bottom: 16.0.s + MediaQuery.paddingOf(context).bottom,
                ),
                child: Button(
                  disabled: loginActionState.isLoading,
                  trailingIcon: loginActionState.isLoading ? const IceLoadingIndicator() : null,
                  label: Text(context.i18n.button_continue),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () async {
                    await ref.read(onboardingDataProvider.notifier).finish();
                    if (context.mounted) {
                      if (hasNotificationsPermission) {
                        FeedRoute().go(context);
                      } else {
                        NotificationsRoute().go(context);
                      }
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
