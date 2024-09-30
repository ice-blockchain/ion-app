import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/permissions/data/models/models.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionAwareWidget extends HookConsumerWidget {
  const PermissionAwareWidget({
    required this.permissionType,
    required this.buildWithPermission,
    required this.buildWithoutPermission,
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  final AppPermissionType permissionType;
  final WidgetBuilder buildWithPermission;
  final WidgetBuilder buildWithoutPermission;
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionsNotifier = ref.watch(permissionsProvider.notifier);
    final hasPermission = useState(false);

    useEffect(
      () {
        Future<void> checkPermission() async {
          final isGranted = await permissionsNotifier.checkAndRequestPermission(permissionType);
          hasPermission.value = isGranted;

          if (isGranted) {
            onPermissionGranted?.call();
          } else {
            onPermissionDenied?.call();

            if (context.mounted) {
              await _showPermissionDialog(context, ref);
            }
          }
        }

        checkPermission();
        return null;
      },
      [permissionType],
    );

    return hasPermission.value ? buildWithPermission(context) : buildWithoutPermission(context);
  }

  Future<void> _showPermissionDialog(BuildContext context, WidgetRef ref) async {
    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission required'),
        content: const Text('Please allow the app to access the required permission.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open settings'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings ?? false) {
      await openAppSettings();
      final permissionsNotifier = ref.read(permissionsProvider.notifier);
      if (await permissionsNotifier.checkAndRequestPermission(permissionType)) {
        onPermissionGranted?.call();
      }
    }
  }
}
