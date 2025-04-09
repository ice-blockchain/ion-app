// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/strategies/permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// A base class responsible for handling permissions using the `permission_handler` package.
class PermissionHandlerStrategy extends PermissionStrategy {
  PermissionHandlerStrategy(this.permissionType);

  final Permission permissionType;

  @override
  Future<void> openSettings() async => ph.openAppSettings();

  @override
  Future<PermissionStatus> checkPermission() async {
    if (_isAndroidPhotosPermission()) {
      return _handleAndroidPhotosPermissionCheck();
    } else {
      return _handleGenericPermissionCheck();
    }
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    if (_isAndroidPhotosPermission()) {
      return _handleAndroidPhotosPermissionRequest();
    } else {
      return _handleGenericPermissionRequest();
    }
  }

  bool _isAndroidPhotosPermission() {
    return !kIsWeb && Platform.isAndroid && permissionType == Permission.photos;
  }

  Future<PermissionStatus> _handleAndroidPhotosPermissionCheck() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      return _mapToAppPermission(await ph.Permission.storage.status);
    } else {
      return _mapToAppPermission(await _aggregateAndroidPhotosAndVideosStatus());
    }
  }

  Future<PermissionStatus> _handleAndroidPhotosPermissionRequest() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      return _mapToAppPermission(await ph.Permission.storage.request());
    } else {
      return _mapToAppPermission(await _aggregateAndroidPhotosAndVideosRequest());
    }
  }

  Future<PermissionStatus> _handleGenericPermissionCheck() async {
    final permission = await _getPermission();
    return _mapToAppPermission(await permission.status);
  }

  Future<PermissionStatus> _handleGenericPermissionRequest() async {
    final permission = await _getPermission();
    return _mapToAppPermission(await permission.request());
  }

  Future<ph.PermissionStatus> _aggregateAndroidPhotosAndVideosStatus() async {
    final permissions = [ph.Permission.photos, ph.Permission.videos];
    final statuses = await Future.wait(permissions.map((permission) => permission.status));
    return _combineStatuses(statuses);
  }

  Future<ph.PermissionStatus> _aggregateAndroidPhotosAndVideosRequest() async {
    final permissions = [ph.Permission.photos, ph.Permission.videos];
    final statuses = (await permissions.request()).values.toList();
    return _combineStatuses(statuses);
  }

  ph.PermissionStatus _combineStatuses(List<ph.PermissionStatus> statuses) {
    if (statuses.any((status) => status.isDenied)) {
      return ph.PermissionStatus.denied;
    } else if (statuses.every((status) => status.isGranted)) {
      return ph.PermissionStatus.granted;
    } else if (statuses.any((status) => status.isLimited)) {
      return ph.PermissionStatus.limited;
    } else if (statuses.any((status) => status.isPermanentlyDenied)) {
      return ph.PermissionStatus.permanentlyDenied;
    } else {
      return ph.PermissionStatus.denied;
    }
  }

  PermissionStatus _mapToAppPermission(ph.PermissionStatus status) {
    return switch (status) {
      ph.PermissionStatus.granted => PermissionStatus.granted,
      ph.PermissionStatus.denied => PermissionStatus.denied,
      ph.PermissionStatus.restricted => PermissionStatus.restricted,
      ph.PermissionStatus.limited => PermissionStatus.limited,
      ph.PermissionStatus.permanentlyDenied => PermissionStatus.permanentlyDenied,
      ph.PermissionStatus.provisional => PermissionStatus.provisional,
    };
  }

  Future<ph.Permission> _getPermission() async {
    return switch (permissionType) {
      Permission.camera => ph.Permission.camera,
      Permission.notifications => ph.Permission.notification,
      Permission.photos => ph.Permission.photos,
      Permission.cloud => ph.Permission.unknown,
      Permission.microphone => ph.Permission.microphone,
    };
  }
}
