import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';

bool? hasContactsPermissionSelector(WidgetRef ref) {
  return ref.watch(
    permissionsProvider.select(
      (Map<PermissionType, bool> permissions) =>
          permissions[PermissionType.Contacts],
    ),
  );
}
