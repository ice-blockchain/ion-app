// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/components/background_picture/background_picture.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/components/profile_avatar/profile_avatar.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_details.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/tab_content.dart';
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

    final scrollController = useScrollController();
    final opacityValue = useState<double>(0.0.s);
    final paddingTop = 60.0.s;

    useEffect(
      () {
        void listener() {
          opacityValue.value = (scrollController.offset / paddingTop).clamp(0.0, 1.0);
        }

        scrollController.addListener(listener);
        return () => scrollController.removeListener(listener);
      },
      [scrollController, paddingTop],
    );

    final backgroundColor = context.theme.appColors.secondaryBackground;

    return Scaffold(
      body: ColoredBox(
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              child: Opacity(
                opacity: 1.0 - opacityValue.value,
                child: BackgroundPicture(pubkey: pubkey),
              ),
            ),
            ScreenTopOffset(
              child: CustomScrollView(
                controller: scrollController,
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
                              ProfileAvatar(
                                pubkey: pubkey,
                              ),
                              ProfileDetails(
                                pubkey: pubkey,
                              ),
                              SizedBox(
                                height: 16.0.s,
                              ),
                              const HorizontalSeparator(),
                              SizedBox(
                                height: 16.0.s,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PinnedHeaderSliver(
                    child: ColoredBox(
                      color: backgroundColor,
                      child: Column(
                        children: [
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
                  ),
                  const TabHeader(),
                  TabContent(
                    tab: activeTab.value,
                    pubkey: pubkey,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: paddingTop - HeaderAction.buttonSize),
                color: backgroundColor.withOpacity(opacityValue.value),
                child: Header(
                  opacity: opacityValue.value,
                  pubkey: pubkey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
