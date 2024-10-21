// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/components/background_picture/background_picture.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_details.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/articles_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/posts_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/replies_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/videos_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tab_header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tabs_header/tabs_header.dart';

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
            PostsTab(pubkey: pubkey),
          ];
        case UserContentType.replies:
          return [
            RepliesTab(pubkey: pubkey),
          ];
        case UserContentType.videos:
          return [
            VideosTab(pubkey: pubkey),
          ];
        case UserContentType.articles:
          return [
            ArticlesTab(pubkey: pubkey),
          ];
      }
    }

    return Scaffold(
      body: Stack(
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
                            HorizontalSeparator(
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
              const TabHeader(),
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
    );
  }
}
