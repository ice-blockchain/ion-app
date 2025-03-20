// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/tab_entity_type.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/components/profile_avatar/profile_avatar.dart';
import 'package:ion/app/features/user/pages/components/user_banner/user_banner.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_details.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content_separator.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tab_entities_list.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tabs_header/tabs_header.dart';
import 'package:ion/app/features/user/pages/profile_page/hooks/use_animated_opacity_on_scroll.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';
import 'package:ion/app/features/user/providers/tab_data_source_provider.c.dart';

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
    final scrollController = useScrollController();
    final tabBarController = useTabController(initialLength: UserContentType.values.length);

    final (:opacity) = useAnimatedOpacityOnScroll(scrollController, topOffset: paddingTop);
    final backgroundColor = context.theme.appColors.secondaryBackground;

    return Scaffold(
      body: ColoredBox(
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              child: Opacity(
                opacity: 1.0 - opacity,
                child: UserBanner(pubkey: pubkey),
              ),
            ),
            ScreenTopOffset(
              child: PullToRefreshBuilder(
                slivers: [
                  PinnedHeaderSliver(
                    child: SizedBox(height: paddingTop),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.s)),
                          ),
                          child: Column(
                            children: [
                              ProfileAvatar(pubkey: pubkey),
                              ProfileDetails(pubkey: pubkey),
                              SizedBox(height: 16.0.s),
                              const HorizontalSeparator(),
                              SizedBox(height: 16.0.s),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PinnedHeaderSliver(
                    child: ColoredBox(
                      color: backgroundColor,
                      child: ProfileTabsHeader(
                        controller: tabBarController,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: ContentSeparator(),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: tabBarController,
                      children: TabEntityType.values
                          .map(
                            (type) => type == TabEntityType.replies
                                ? TabEntitiesList.replies(pubkey: pubkey)
                                : TabEntitiesList(pubkey: pubkey, type: type),
                          )
                          .toList(),
                    ),
                  ),
                ],
                onRefresh: () async {
                  final type = TabEntityType.values[tabBarController.index];
                  final dataSource = ref.watch(tabDataSourceProvider(type: type, pubkey: pubkey));
                  ref
                    ..invalidate(
                      entitiesPagedDataProvider(dataSource),
                    )
                    ..invalidate(
                      followersCountProvider(
                        pubkey: pubkey,
                        type: EventCountResultType.followers,
                      ),
                    );
                },
                builder: (context, slivers) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                  body: CustomScrollView(
                    controller: scrollController,
                    slivers: slivers,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: paddingTop - HeaderAction.buttonSize),
                color: backgroundColor.withValues(alpha: opacity),
                child: Header(
                  opacity: opacity,
                  pubkey: pubkey,
                  showBackButton: showBackButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
