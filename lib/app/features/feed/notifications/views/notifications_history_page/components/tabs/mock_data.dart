// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/notifications/data/model/notification_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';

final mockedNotificationDataArray = [
  NotificationData(
    id: '1',
    type: NotificationsType.follow,
    pubkeys: List<String>.filled(2, ''),
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  NotificationData(
    id: '2',
    type: NotificationsType.like,
    pubkeys: List<String>.filled(12, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
  ),
  NotificationData(
    id: '3',
    type: NotificationsType.follow,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
  ),
  NotificationData(
    id: '4',
    type: NotificationsType.reply,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 4)),
  ),
  NotificationData(
    id: '5',
    type: NotificationsType.likeReply,
    pubkeys: List<String>.filled(6, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
  ),
  NotificationData(
    id: '6',
    type: NotificationsType.reply,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 6)),
  ),
  NotificationData(
    id: '7',
    type: NotificationsType.like,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 7)),
  ),
  NotificationData(
    id: '8',
    type: NotificationsType.likeReply,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 8)),
  ),
  NotificationData(
    id: '9',
    type: NotificationsType.share,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 9)),
  ),
  NotificationData(
    id: '10',
    type: NotificationsType.like,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 10)),
  ),
  NotificationData(
    id: '11',
    type: NotificationsType.repost,
    pubkeys: List<String>.filled(1, ''),
    timestamp: DateTime.now().subtract(const Duration(days: 11)),
  ),
];
