// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/notifications/notification_data.dart';
import 'package:ion/app/features/feed/data/models/notifications/notifications_type.dart';
import 'package:ion/app/features/feed/data/models/notifications/time_unit_type.dart';

final mockedNotificationDataArray = [
  NotificationData(
    id: '1',
    type: NotificationsType.follow,
    userPubkeys: List<String>.filled(2, ''),
    timeValue: 1,
    timeUnitType: TimeUnitType.hours,
  ),
  NotificationData(
    id: '2',
    type: NotificationsType.like,
    userPubkeys: List<String>.filled(12, ''),
    timeValue: 2,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '3',
    type: NotificationsType.follow,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 3,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '4',
    type: NotificationsType.reply,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 4,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '5',
    type: NotificationsType.likeReply,
    userPubkeys: List<String>.filled(6, ''),
    timeValue: 5,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '6',
    type: NotificationsType.reply,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 6,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '7',
    type: NotificationsType.like,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 7,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '8',
    type: NotificationsType.likeReply,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 8,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '9',
    type: NotificationsType.share,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 9,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '10',
    type: NotificationsType.like,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 10,
    timeUnitType: TimeUnitType.days,
  ),
  NotificationData(
    id: '11',
    type: NotificationsType.repost,
    userPubkeys: List<String>.filled(1, ''),
    timeValue: 11,
    timeUnitType: TimeUnitType.days,
  ),
];
