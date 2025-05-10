// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_notifications.c.g.dart';

class LocalNotificationsService {
  LocalNotificationsService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  final _notificationResponseController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationResponseStream =>
      _notificationResponseController.stream;

  Future<void> initialize() async {
    await _plugin.initialize(
      _settings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null) {
          _notificationResponseController.sink.add(
            jsonDecode(payload) as Map<String, dynamic>,
          );
        }
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  Future<Map<String, dynamic>?> getInitialNotificationData() async {
    final initialNotification = await _plugin.getNotificationAppLaunchDetails();
    final payload = initialNotification?.notificationResponse?.payload;
    return payload != null ? jsonDecode(payload) as Map<String, dynamic> : null;
  }

  static InitializationSettings get _settings {
    const initializationSettingsAndroid = AndroidInitializationSettings('ic_stat_ic_notification');
    const initializationSettingsDarwin = DarwinInitializationSettings();
    return const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );
  }

  static NotificationDetails get _notificationDetails {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'ion_miscellaneous',
      'Miscellaneous',
      color: Color(0xFF0166FF),
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    return const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }
}

@Riverpod(keepAlive: true)
LocalNotificationsService localNotificationsService(Ref ref) => LocalNotificationsService();
