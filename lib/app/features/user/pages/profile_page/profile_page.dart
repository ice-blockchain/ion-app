// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/model/tab_entity_type.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/components/profile_avatar/profile_avatar.dart';
import 'package:ion/app/features/user/pages/profile_page/cant_find_profile_page.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_details.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content_separator.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tab_entities_list.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tabs_header/tabs_header.dart';
import 'package:ion/app/features/user/pages/profile_page/hooks/use_animated_opacity_on_scroll.dart';
import 'package:ion/app/features/user/pages/profile_page/profile_skeleton.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({
    required this.pubkey,
    this.showBackButton = true,
    super.key,
  });

  final String pubkey;
  final bool showBackButton;

  double get paddingTop => 60.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleted = ref.watch(isUserDeletedProvider(pubkey)).valueOrNull.falseOrValue;
    final isBlockedOrBlockedBy =
        ref.watch(isBlockedOrBlockedByNotifierProvider(pubkey)).valueOrNull.falseOrValue;

    if (isDeleted || isBlockedOrBlockedBy) {
      return const CantFindProfilePage();
    }

    final userMetadata = ref.watch(userMetadataProvider(pubkey));

    final didRefresh = useState(false);

    final isLoading = !didRefresh.value && (userMetadata.isLoading || !userMetadata.hasValue);

    if (isLoading) {
      return ProfileSkeleton(showBackButton: showBackButton);
    }

    final scrollController = useScrollController();
    if (!showBackButton) {
      useScrollTopOnTabPress(context, scrollController: scrollController);
    }
    final (:opacity) = useAnimatedOpacityOnScroll(scrollController, topOffset: paddingTop);

    final backgroundColor = context.theme.appColors.secondaryBackground;

    final onRefresh = useCallback(
      () {
        didRefresh.value = true;
        if (userMetadata.value == null) return;
        ref.read(ionConnectCacheProvider.notifier).remove(userMetadata.value!.cacheKey);
        ref.read(ionConnectCacheProvider.notifier).remove(
              EventCountResultEntity.cacheKeyBuilder(
                key: pubkey,
                type: EventCountResultType.followers,
              ),
            );
      },
      [userMetadata.value?.cacheKey],
    );

    return Scaffold(
      body: ColoredBox(
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ScreenTopOffset(
              child: DefaultTabController(
                length: UserContentType.values.length,
                child: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      PinnedHeaderSliver(
                        child: ColoredBox(
                          color: backgroundColor,
                          child: Header(
                            pubkey: pubkey,
                            opacity: opacity,
                            showBackButton: showBackButton,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 16.0.s),
                            ProfileDetails(pubkey: pubkey),
                            SizedBox(height: 16.0.s),
                            const HorizontalSeparator(),
                            SizedBox(height: 16.0.s),
                          ],
                        ),
                      ),
                      PinnedHeaderSliver(
                        child: ColoredBox(
                          color: backgroundColor,
                          child: const ProfileTabsHeader(),
                        ),
                      ),
                      const SliverToBoxAdapter(child: ContentSeparator()),
                    ];
                  },
                  body: TabBarView(
                    children: TabEntityType.values
                        .map(
                          (type) => type == TabEntityType.replies
                              ? TabEntitiesList.replies(
                                  pubkey: pubkey,
                                  onRefresh: onRefresh,
                                )
                              : TabEntitiesList(
                                  pubkey: pubkey,
                                  type: type,
                                  onRefresh: onRefresh,
                                ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            // need to move ProfileAvatar here to fix the issue with the header action
            // because header overlaps the ProfileAvatar
            FittedBox(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(top: paddingTop),
                  child: Opacity(
                    opacity: 1 - opacity,
                    child: ProfileAvatar(pubkey: pubkey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
