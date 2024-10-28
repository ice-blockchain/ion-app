// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/components/background_picture/background_picture.dart';
import 'package:ion/app/features/user/pages/components/profile_avatar/profile_avatar.dart';
import 'package:ion/app/features/user/pages/components/user_name_tile/user_name_tile.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/followed_by/followed_by.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_about.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/edit_profile_actions.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/profile_actions.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_followers.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/user_info/user_info.dart';
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
    final isCurrentUserProfile = ref.watch(isCurrentUserSelectorProvider(pubkey));
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
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.appColors.secondaryBackground,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.s)),
                        ),
                        child: ScreenSideOffset.small(
                          child: Column(
                            children: [
                              ProfileAvatar(
                                pubkey: pubkey,
                              ),
                              UserNameTile(pubkey: pubkey),
                              SizedBox(height: 8.0.s),
                              if (isCurrentUserProfile)
                                EditProfileActions(
                                  pubkey: pubkey,
                                )
                              else
                                ProfileActions(
                                  pubkey: pubkey,
                                ),
                              SizedBox(height: 16.0.s),
                              ProfileFollowers(
                                pubkey: pubkey,
                              ),
                              SizedBox(height: 10.0.s),
                              FollowedBy(pubkey: pubkey),
                              SizedBox(height: 12.0.s),
                              ProfileAbout(pubkey: pubkey),
                              SizedBox(height: 12.0.s),
                              UserInfo(pubkey: pubkey),
                            ],
                          ),
                        ),
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
