// ignore_for_file: constant_identifier_names

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider.g.dart';

enum PermissionType { Contacts, Notifications }

typedef PermissionCallback = void Function();

@Riverpod(keepAlive: true)
class Permissions extends _$Permissions {
  @override
  Map<PermissionType, PermissionStatus> build() {
    return Map<PermissionType, PermissionStatus>.unmodifiable(
      <PermissionType, PermissionStatus>{},
    );
  }

  Future<void> checkAllPermissions() async {
    final permissions = <PermissionType, PermissionStatus>{};
    final contactsPermissionStatus = await Permission.contacts.status;
    final notificationsPermissionStatus = await Permission.notification.status;
    permissions
      ..putIfAbsent(
        PermissionType.Notifications,
        () => notificationsPermissionStatus,
      )
      ..putIfAbsent(
        PermissionType.Contacts,
        () => contactsPermissionStatus,
      );
    state = Map<PermissionType, PermissionStatus>.unmodifiable(permissions);
  }

  Future<void> requestPermission(
    PermissionType permissionType, {
    PermissionCallback? onDenied,
    PermissionCallback? onGranted,
    PermissionCallback? onPermanentlyDenied,
    PermissionCallback? onRestricted,
    PermissionCallback? onLimited,
    PermissionCallback? onProvisional,
  }) async {
    late Permission permission;
    switch (permissionType) {
      case PermissionType.Contacts:
        permission = Permission.contacts;
      case PermissionType.Notifications:
        permission = Permission.notification;
    }

    final permissionStatus = await permission.request();

    switch (permissionStatus) {
      case PermissionStatus.denied:
        if (onDenied != null) onDenied();
      case PermissionStatus.granted:
        if (onGranted != null) onGranted();
      case PermissionStatus.permanentlyDenied:
        if (onPermanentlyDenied != null) onPermanentlyDenied();
      case PermissionStatus.restricted:
        if (onRestricted != null) onRestricted();
      case PermissionStatus.limited:
        if (onLimited != null) onLimited();
      case PermissionStatus.provisional:
        if (onProvisional != null) onProvisional();
    }

    final newState = Map<PermissionType, PermissionStatus>.from(state)
      ..update(
        permissionType,
        (_) => permissionStatus,
        ifAbsent: () => permissionStatus,
      );
    state = Map<PermissionType, PermissionStatus>.unmodifiable(newState);
  }

  PermissionStatus? getPermissionStatusForType(PermissionType type) {
    return state[type];
  }
}
