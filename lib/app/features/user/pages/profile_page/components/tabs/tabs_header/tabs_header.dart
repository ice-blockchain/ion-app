// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/tabs_header/tabs_header_tab.dart';

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
      children: UserContentType.values.map((tabType) {
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
