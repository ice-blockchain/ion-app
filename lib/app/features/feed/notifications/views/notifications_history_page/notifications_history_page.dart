// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/section_separator/section_separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_tab_type.dart';
import 'package:ion/app/features/feed/notifications/providers/unread_notifications_count_provider.c.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs/notifications_tab.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs_header/tabs_header.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class NotificationsHistoryPage extends HookConsumerWidget {
  const NotificationsHistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnInit(ref.read(unreadNotificationsCountProvider.notifier).readAll);

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
              const SectionSeparator(),
              Expanded(
                child: TabBarView(
                  children: NotificationsTabType.values
                      .map((type) => NotificationsTab(type: type))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
