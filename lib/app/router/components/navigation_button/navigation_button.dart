// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_replies_subscription_provider.c.dart';

class NavigationButton extends ConsumerWidget {
  const NavigationButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.size,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final double? size;

  static double get defaultSize => 40.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationsRepliesSubscriptionProvider);

    return Button.icon(
      type: ButtonType.menuInactive,
      size: size ?? defaultSize,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
