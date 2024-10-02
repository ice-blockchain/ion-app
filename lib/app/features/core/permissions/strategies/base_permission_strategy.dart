import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/strategies/permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class BasePermissionStrategy implements PermissionStrategy {
  Permission get permission;

  @override
  Future<void> openSettings() async => openAppSettings();

  @override
  Future<AppPermissionStatus> checkPermission() async {
    final status = await permission.status;

    return _mapToAppPermission(status);
  }

  @override
  Future<AppPermissionStatus> requestPermission() async {
    final status = await permission.request();

    return _mapToAppPermission(status);
  }

  AppPermissionStatus _mapToAppPermission(PermissionStatus status) => switch (status) {
        PermissionStatus.granted => AppPermissionStatus.granted,
        PermissionStatus.denied => AppPermissionStatus.denied,
        PermissionStatus.restricted => AppPermissionStatus.restricted,
        PermissionStatus.limited => AppPermissionStatus.limited,
        PermissionStatus.permanentlyDenied => AppPermissionStatus.permanentlyDenied,
        PermissionStatus.provisional => AppPermissionStatus.provisional,
      };
}
