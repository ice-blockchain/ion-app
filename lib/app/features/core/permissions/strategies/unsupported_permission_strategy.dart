import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/strategies/permission_strategy.dart';

class UnsupportedPermissionStrategy implements PermissionStrategy {
  @override
  Future<AppPermissionStatus> checkPermission() async {
    return Future.value(AppPermissionStatus.notAvailable);
  }

  @override
  Future<AppPermissionStatus> requestPermission() async {
    return Future.value(AppPermissionStatus.notAvailable);
  }
}
