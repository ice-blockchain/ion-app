// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'device_id.r.g.dart';

class DeviceIdService {
  final DeviceIdDelegate _delegate = DeviceIdDelegate.forPlatform();

  String? _deviceId;

  Future<String> get() async {
    if (_deviceId != null) {
      return _deviceId!;
    }
    return _deviceId = await _delegate.getDeviceId();
  }
}

abstract class DeviceIdDelegate {
  factory DeviceIdDelegate.forPlatform() {
    if (!kIsWeb && Platform.isAndroid) {
      return AndroidDeviceIdDelegate();
    } else if (!kIsWeb && Platform.isIOS) {
      return IOSDeviceIdDelegate();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<String> getDeviceId();
}

class AndroidDeviceIdDelegate implements DeviceIdDelegate {
  static const String _deviceIdKey = 'device_id';

  @override
  Future<String> getDeviceId() async {
    final androidId = await const AndroidId().getId();
    if (androidId != null) {
      return androidId;
    } else {
      final sharedPrefs = await SharedPreferences.getInstance();
      if (sharedPrefs.containsKey(_deviceIdKey)) {
        return sharedPrefs.getString(_deviceIdKey)!;
      } else {
        final uuid = generateUuid();
        await sharedPrefs.setString(_deviceIdKey, uuid);
        return uuid;
      }
    }
  }
}

class IOSDeviceIdDelegate implements DeviceIdDelegate {
  static const String _deviceIdKey = 'device_id';
  static const String _deviceIdAccountName = 'device_id_account';

  @override
  Future<String> getDeviceId() async {
    const storage = FlutterSecureStorage();
    // Using non-empty account name to avoid the default keychain cleanup on app reinstall
    const iOSOptions = IOSOptions(accountName: _deviceIdAccountName);
    final deviceId = await storage.read(key: _deviceIdKey, iOptions: iOSOptions);
    if (deviceId != null) {
      return deviceId;
    } else {
      final uuid = generateUuid();
      await storage.write(key: _deviceIdKey, value: uuid, iOptions: iOSOptions);
      return uuid;
    }
  }
}

@Riverpod(keepAlive: true)
DeviceIdService deviceIdService(Ref ref) => DeviceIdService();
