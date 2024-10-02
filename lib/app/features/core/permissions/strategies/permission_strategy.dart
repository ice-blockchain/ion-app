import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';

abstract class PermissionStrategy {
  Future<AppPermissionStatus> checkPermission();
  Future<AppPermissionStatus> requestPermission();
  Future<void>? openSettings();
}
