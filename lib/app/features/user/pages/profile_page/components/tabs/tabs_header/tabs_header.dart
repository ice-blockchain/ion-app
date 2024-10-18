// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/pages/profile_page/components/tabs/tabs_header/tabs_header_tab.dart';
import 'package:ice/app/features/user/pages/profile_page/types/user_content_type.dart';

class ProfileTabsHeader extends ConsumerWidget {
  const ProfileTabsHeader({
    required this.activeTab,
    required this.onTabSwitch,
    super.key,
  });

  final UserContentType activeTab;
  final void Function(UserContentType newTab) onTabSwitch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserContentType.posts,
        UserContentType.replies,
        UserContentType.videos,
        UserContentType.articles,
      ].map((tabType) {
        return Expanded(
          child: ProfileTabsHeaderTab(
            isActive: activeTab == tabType,
            tabType: tabType,
            onTap: () => onTabSwitch(tabType),
          ),
        );
      }).toList(),
    );
  }
}
