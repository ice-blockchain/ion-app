// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/models/global_notification_data.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_provider.c.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_state.c.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/providers/repost_notifier.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story_camera_state.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_camera_provider.c.dart';

const _animationDuration = Duration(milliseconds: 500);
const _notificationHeight = 24.0;

class GlobalNotificationBar extends HookConsumerWidget {
  const GlobalNotificationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(globalNotificationProvider);

    _setupListeners(ref);

    final controller = useAnimationController(
      duration: _animationDuration,
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    _controlAnimation(notificationState, animation, controller);

    final data = notificationState.data;

    if (data == null) {
      return const SizedBox.shrink();
    }

    final icon = data.getIcon(context);

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 1,
      child: SizedBox(
        height: _notificationHeight.s,
        child: ColoredBox(
          color: data.getBackgroundColor(context),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 8.0.s),
                    child: icon,
                  ),
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
    );
  }

  void _controlAnimation(
    GlobalNotificationState? notificationState,
    CurvedAnimation animation,
    AnimationController controller,
  ) {
    if (notificationState != null &&
        notificationState.isShow &&
        animation.status != AnimationStatus.completed) {
      controller.forward();
    } else if (animation.status != AnimationStatus.dismissed) {
      controller.animateBack(0, duration: _animationDuration);
    }
  }

  void _setupListeners(WidgetRef ref) {
    ref
      ..listen(createPostNotifierProvider, (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.post);
      })
      ..listen(repostNotifierProvider, (previous, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.repost);
      })
      ..listen<StoryCameraState>(storyCameraControllerProvider, (previous, next) {
        if (next is StoryCameraUploading) {
          _handleNotification(
            ref,
            notifier: const AsyncValue.loading(),
            type: NotificationContentType.story,
          );
        }

        if (next is StoryCameraPublished) {
          _handleNotification(
            ref,
            notifier: const AsyncValue.data(null),
            type: NotificationContentType.story,
          );
        }
      });
  }

  void _handleNotification(
    WidgetRef ref, {
    required AsyncValue<void> notifier,
    required NotificationContentType type,
  }) {
    GlobalNotificationData? notificationData;

    if (notifier.isLoading) notificationData = type.loading();
    if (notifier.hasValue) notificationData = type.ready();

    if (notificationData != null) {
      ref.read(globalNotificationProvider.notifier).show(
            notificationData,
          );
    }
  }
}
