// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/content_notification/data/models/content_notification_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_notification_provider.c.g.dart';

@riverpod
class ContentNotificationController extends _$ContentNotificationController {
  @override
  NotificationData? build() => null;

  void showLoading(ContentType contentType) => state = NotificationData.loading(contentType);

  void showPublished(ContentType contentType) => state = NotificationData.published(contentType);

  void showSuccess(ContentType contentType) => state = NotificationData.success(contentType);

  void hideNotification() => state = null;
}
