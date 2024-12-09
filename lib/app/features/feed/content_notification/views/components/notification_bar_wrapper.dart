// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/content_notification/providers/content_notification_provider.c.dart';
import 'package:ion/app/features/feed/content_notification/views/components/content_notification_bar.dart';

class NotificationBarWrapper extends ConsumerWidget {
  const NotificationBarWrapper({required this.child, super.key});

  final Widget child;

  static double get notificationHeight => 24.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationData = ref.watch(contentNotificationControllerProvider);
    return Stack(
      children: [
        AnimatedPositioned(
          duration: 300.ms,
          top: notificationData != null ? notificationHeight : 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: child,
        ),
        if (notificationData != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ContentNotificationBar(
              key: ValueKey(notificationData),
              data: notificationData,
              height: notificationHeight,
            ),
          ),
      ],
    );
  }
}
