import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:permission_handler/permission_handler.dart';

bool? hasPermissionSelector(WidgetRef ref, PermissionType permissionType) {
  return ref.watch(
    permissionsProvider.select(
      (Map<PermissionType, PermissionStatus> permissions) =>
          permissions[permissionType] == PermissionStatus.granted,
    ),
  );
}
