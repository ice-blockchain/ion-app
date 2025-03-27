// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/user/model/tab_entity_type.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/components/profile_avatar/profile_avatar.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_details.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content_separator.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tab_entities_list.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tabs_header/tabs_header.dart';
import 'package:ion/app/features/user/pages/profile_page/hooks/use_animated_opacity_on_scroll.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';

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
    useOnInit(
      () {
        ref.invalidate(
          followersCountProvider(pubkey: pubkey, type: EventCountResultType.followers),
        );
      },
    );

    final scrollController = useScrollController();
    final (:opacity) = useAnimatedOpacityOnScroll(scrollController, topOffset: paddingTop);

    final backgroundColor = context.theme.appColors.secondaryBackground;

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
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            ProfileAvatar(pubkey: pubkey),
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
                              ? TabEntitiesList.replies(pubkey: pubkey)
                              : TabEntitiesList(pubkey: pubkey, type: type),
                        )
                        .toList(),
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
