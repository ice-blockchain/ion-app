// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/providers/login_action_notifier.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/descriptions.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/notifications.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/providers/permissions_provider.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class TurnOnNotifications extends ConsumerWidget {
  const TurnOnNotifications({super.key});

  void handleSignIn(WidgetRef ref) {
    ref.read(loginActionNotifierProvider.notifier).signIn(keyName: '123');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.0.s),
            child: AuthHeader(
              title: context.i18n.turn_notifications_title,
              description: context.i18n.turn_notifications_description,
              descriptionSidePadding: 12.0.s,
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Notifications(),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24.0.s)),
                const SliverToBoxAdapter(
                  child: Descriptions(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 76.0.s),
                      ScreenSideOffset.small(
                        child: Button(
                          label: Text(context.i18n.button_continue),
                          mainAxisSize: MainAxisSize.max,
                          onPressed: () {
                            ref
                                .read(permissionsProvider.notifier)
                                .requestPermission(
                                  Permission.notifications,
                                )
                                .then((_) => handleSignIn(ref));
                          },
                        ),
                      ),
                      SizedBox(height: 50.0.s),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
