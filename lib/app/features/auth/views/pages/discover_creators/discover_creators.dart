// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_notifier.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/pages/discover_creators/creator_list_item.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.dart';
import 'package:ion/app/features/user/providers/user_following_provider.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class DiscoverCreators extends HookConsumerWidget {
  const DiscoverCreators({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishNotifier = ref.watch(onboardingCompleteNotifierProvider);
    final onboardingComplete = ref.watch(onboardingCompleteProvider);
    final hasNotificationsPermission = ref.watch(hasPermissionProvider(Permission.notifications));
    final currentUserId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final followingIds = ref.watch(userFollowingProvider(currentUserId));

    final mayContinue = followingIds.valueOrNull?.isNotEmpty ?? false;
    final creatorIds = [
      'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
      '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
    ];

    useOnInit(
      () {
        if (onboardingComplete.valueOrNull.falseOrValue) {
          if (hasNotificationsPermission) {
            FeedRoute().go(context);
          } else {
            NotificationsRoute().go(context);
          }
        }
      },
      [onboardingComplete.valueOrNull],
    );

    return SheetContent(
      body: Column(
        children: [
          Expanded(
            child: AuthScrollContainer(
              title: context.i18n.discover_creators_title,
              description: context.i18n.discover_creators_description,
              slivers: [
                SliverPadding(padding: EdgeInsets.only(top: 34.0.s)),
                SliverList.separated(
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: 8.0.s,
                  ),
                  itemCount: creatorIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CreatorListItem(userId: creatorIds[index]);
                  },
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s + (mayContinue ? 0 : MediaQuery.paddingOf(context).bottom),
                  ),
                ),
              ],
            ),
          ),
          if (mayContinue)
            Column(
              children: [
                const HorizontalSeparator(),
                SizedBox(height: 16.0.s),
                ScreenSideOffset.small(
                  child: Button(
                    disabled: finishNotifier.isLoading,
                    trailingIcon: finishNotifier.isLoading ? const IceLoadingIndicator() : null,
                    label: Text(context.i18n.button_continue),
                    mainAxisSize: MainAxisSize.max,
                    onPressed: () {
                      ref.read(onboardingDataProvider.notifier).followees = creatorIds;
                      ref.read(onboardingCompleteNotifierProvider.notifier).finish();
                    },
                  ),
                ),
                SizedBox(height: 8.0.s + MediaQuery.paddingOf(context).bottom),
              ],
            ),
        ],
      ),
    );
  }
}
