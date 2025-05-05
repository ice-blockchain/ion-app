// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:async/async.dart';
import 'package:ion/app/components/global_notification_bar/global_notification_bar.dart';
import 'package:ion/app/components/global_notification_bar/models/global_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_notification_notifier_provider.c.g.dart';

// TODO: should we add a queue of messages like in `UiEventQueueNotifier`?
// Or even reuse the `UiEventQueueNotifier`?
@riverpod
class GlobalNotificationNotifier extends _$GlobalNotificationNotifier {
  @override
  GlobalNotification? build() => null;

  Timer? _hideTimer;
  CancelableOperation<void>? _cancelableShowOperation;

  static const _notificationDuration = Duration(seconds: 3);

  void show(GlobalNotification notification, {bool isPermanent = false}) {
    // Prevent bottom sheet from jumping when showing notification
    _cancelableShowOperation?.cancel();
    _cancelableShowOperation = CancelableOperation.fromFuture(
      Future.delayed(
        GlobalNotificationBar.animationDuration,
        () => state = notification,
      ),
    );

    _hideTimer?.cancel();

    if (!isPermanent) {
      _hideTimer = Timer(_notificationDuration, hide);
    }
  }

  void hide() {
    _hideTimer?.cancel();
    state = null;
  }
}
