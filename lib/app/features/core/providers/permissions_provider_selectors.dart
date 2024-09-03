import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_provider_selectors.g.dart';

@riverpod
bool hasPermissionSelector(HasPermissionSelectorRef ref, PermissionType permissionType) {
  return ref.watch(
    permissionsProvider.select(
      (permissions) => permissions[permissionType] == PermissionStatus.granted,
    ),
  );
}
