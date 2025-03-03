// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/global_notification_bar/models/global_notification_data.dart';
import 'package:ion/app/components/global_notification_bar/providers/global_notification_provider.c.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_provider.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/providers/repost_notifier.c.dart';

class GlobalNotificationBar extends HookConsumerWidget {
  const GlobalNotificationBar({super.key});

  static const animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(globalNotificationProvider);

    _setupListeners(ref);

    final controller = useAnimationController(
      duration: animationDuration,
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    _controlAnimation(
      isShow: notificationState.isShow,
      animation: animation,
      controller: controller,
    );

    final data = notificationState.data;

    if (data == null) {
      return const SizedBox.shrink();
    }

    final icon = data.getIcon(context);

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 1,
      child: SizedBox(
        height: 24.0.s,
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

  void _controlAnimation({
    required bool isShow,
    required CurvedAnimation animation,
    required AnimationController controller,
  }) {
    if (isShow && animation.status != AnimationStatus.completed) {
      controller.forward();
    } else if (!isShow && animation.status != AnimationStatus.dismissed) {
      controller.animateBack(0, duration: animationDuration);
    }
  }

  void _setupListeners(WidgetRef ref) {
    ref
      ..listen(createPostNotifierProvider(CreatePostOption.plain), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.post);
      })
      ..listen(createPostNotifierProvider(CreatePostOption.quote), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.post);
      })
      ..listen(createPostNotifierProvider(CreatePostOption.reply), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.reply);
      })
      ..listen(createPostNotifierProvider(CreatePostOption.video), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.video);
      })
      ..listen(createPostNotifierProvider(CreatePostOption.story), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.story);
      })
      ..listen(createPostNotifierProvider(CreatePostOption.modify), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.modify);
      })
      ..listen(createPostNotifierProvider(CreatePostOption.softDelete), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.delete);
      })
      ..listen(createArticleProvider(CreateArticleOption.plain), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.article);
      })
      ..listen(createArticleProvider(CreateArticleOption.softDelete), (_, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.delete);
      })
      ..listen(repostNotifierProvider, (previous, next) {
        _handleNotification(ref, notifier: next, type: NotificationContentType.repost);
      });
  }

  void _handleNotification(
    WidgetRef ref, {
    required AsyncValue<void> notifier,
    required NotificationContentType type,
  }) {
    if (notifier.isLoading) {
      ref.read(globalNotificationProvider.notifier).show(type.loading());
    } else if (notifier.hasError && notifier.error != null) {
      showErrorModal(notifier.error!);
      ref.read(globalNotificationProvider.notifier).hide();
    } else if (notifier.hasValue) {
      ref.read(globalNotificationProvider.notifier).show(type.ready());
    }
  }
}
