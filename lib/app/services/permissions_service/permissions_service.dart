import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_service.g.dart';

enum Permission { contacts, notifications }

enum PermissionStatus {
  /// The permission is granted
  granted,

  /// The permission has not been requested / is denied but requestable
  denied,

  /// The permission is denied and not requestable anymore
  blocked,

  /// This feature is not available (on this device / in this context)
  unavailable
}

class PermissionsService {
  Future<PermissionStatus> check(Permission permission) async {
    if (kIsWeb && permission == Permission.contacts) {
      return PermissionStatus.unavailable;
    }
    final status = await _getHandler(permission).status;
    return _matchStatus(status);
  }

  Future<PermissionStatus> request(Permission permission) async {
    final status = await _getHandler(permission).request();
    return _matchStatus(status);
  }

  handler.Permission _getHandler(Permission permission) {
    return switch (permission) {
      Permission.contacts => handler.Permission.contacts,
      Permission.notifications => handler.Permission.notification,
    };
  }

  PermissionStatus _matchStatus(handler.PermissionStatus status) {
    return switch (status) {
      handler.PermissionStatus.granted ||
      handler.PermissionStatus.provisional =>
        PermissionStatus.granted,
      handler.PermissionStatus.denied => PermissionStatus.denied,
      handler.PermissionStatus.permanentlyDenied => PermissionStatus.blocked,
      _ => PermissionStatus.unavailable,
    };
  }
}

@riverpod
PermissionsService permissionsService(PermissionsServiceRef ref) => PermissionsService();
