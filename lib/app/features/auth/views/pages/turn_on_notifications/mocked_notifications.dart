import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class MockedNotification {
  const MockedNotification({
    required this.title,
    required this.description,
    required this.time,
    required this.image,
    this.iceVerified,
  });

  final String title;
  final String description;
  final String time;
  final Widget image;
  final bool? iceVerified;
}

final iconSide = 36.0.s;

List<MockedNotification> mockedNotifications = <MockedNotification>[
  MockedNotification(
    title: 'Sent ICE',
    description: 'You sent 12.43 ICE to @james',
    time: '15m ago',
    image: Assets.images.notifications.avatar1
        .icon(size: iconSide, fit: BoxFit.contain),
    iceVerified: true,
  ),
  MockedNotification(
    title: 'New follower',
    description: '@curtis has started following you',
    time: '24m ago',
    image: Assets.images.notifications.avatar2.icon(size: iconSide),
  ),
  MockedNotification(
    title: 'New message',
    description: '@marie has sent you a message',
    time: '31m ago',
    image: Assets.images.notifications.avatar3.icon(size: iconSide),
  ),
];
