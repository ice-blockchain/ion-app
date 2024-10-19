// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/components/background_picture/background_picture.dart';
import 'package:ion/app/features/user/pages/profile_page/components/divider/divider.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_details.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/articles_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/posts_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/replies_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/videos_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tab_header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tabs_header/tabs_header.dart';
import 'package:ion/app/features/user/pages/profile_page/types/user_content_type.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = useState<UserContentType>(UserContentType.posts);

    List<Widget> getActiveTabContent() {
      switch (activeTab.value) {
        case UserContentType.posts:
          return [
            const TabHeader(),
            PostsTab(pubkey: pubkey),
          ];
        case UserContentType.replies:
          return [
            const TabHeader(),
            RepliesTab(pubkey: pubkey),
          ];
        case UserContentType.videos:
          return [
            const TabHeader(),
            VideosTab(pubkey: pubkey),
          ];
        case UserContentType.articles:
          return [
            const TabHeader(),
            ArticlesTab(pubkey: pubkey),
          ];
      }
    }

    return Material(
      color: context.theme.appColors.secondaryBackground,
      child: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.velocity.pixelsPerSecond.dx < -100) {
            context.pop();
          }
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              child: BackgroundPicture(pubkey: pubkey),
            ),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ScreenTopOffset(
                    child: Column(
                      children: [
                        SizedBox(height: 60.0.s),
                        ProfileDetails(
                          pubkey: pubkey,
                        ),
                        ColoredBox(
                          color: context.theme.appColors.secondaryBackground,
                          child: Column(
                            children: [
                              ProfileDivider(
                                height: 32.0.s,
                              ),
                              ProfileTabsHeader(
                                activeTab: activeTab.value,
                                onTabSwitch: (UserContentType newTab) {
                                  if (newTab != activeTab.value) {
                                    activeTab.value = newTab;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...getActiveTabContent(),
              ],
            ),
            Positioned(
              child: Header(
                pubkey: pubkey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
