// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';

part 'notification_data.c.freezed.dart';

@freezed
class NotificationData with _$NotificationData {
  const factory NotificationData({
    required String id,
    required NotificationsType type,
    required List<String> pubkeys,
    required DateTime timestamp,
    ModifiablePostEntity? postEntity,
  }) = _NotificationData;
}
