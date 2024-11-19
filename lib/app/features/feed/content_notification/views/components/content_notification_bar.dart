// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/content_notification/data/models/content_notification_data.dart';
import 'package:ion/app/features/feed/content_notification/providers/content_notification_provider.dart';
import 'package:ion/app/features/feed/stories/effects/slide_in_out_effects.dart';

class ContentNotificationBar extends ConsumerWidget {
  const ContentNotificationBar({
    required this.data,
    required this.height,
    super.key,
  });

  final NotificationData data;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Animate(
        key: ValueKey(data),
        effects: topSlideInOutEffects,
        onComplete: (controller) {
          ref.read(contentNotificationControllerProvider.notifier).hideNotification();
        },
        child: SizedBox(
          height: height,
          child: ColoredBox(
            color: data.getBackgroundColor(context),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data.getIcon(context),
                  SizedBox(width: 8.0.s),
                  Text(
                    data.getMessage(context),
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
