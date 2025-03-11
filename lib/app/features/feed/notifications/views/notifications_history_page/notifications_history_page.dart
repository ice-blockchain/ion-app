// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_tab_type.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs/tab_content.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs_header/tabs_header.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class NotificationsHistoryPage extends StatelessWidget {
  const NotificationsHistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(context.i18n.notifications_title),
      ),
      body: ScreenTopOffset(
        child: DefaultTabController(
          length: NotificationsTabType.values.length,
          child: Column(
            children: [
              const NotificationsHistoryTabsHeader(),
              Expanded(
                child: TabBarView(
                  children: NotificationsTabType.values.map((notificationTabType) {
                    return TabContent(tabType: notificationTabType);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
