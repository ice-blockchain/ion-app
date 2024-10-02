import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';

Future<bool> Function() usePermissionHandler(
  WidgetRef ref,
  AppPermissionType type, {
  required Widget requestDialog,
  required Widget deniedDialog,
}) {
  final context = useContext();

  return useMemoized(
    () {
      return () async {
        final permissionsNotifier = ref.read(permissionsProvider.notifier);

        if (permissionsNotifier.hasPermission(type)) {
          return true;
        }

        if (permissionsNotifier.isPermanentlyDenied(type)) {
          final shouldOpenSettings = await showSimpleBottomSheet<bool>(
            context: context,
            child: deniedDialog,
          );

          if (shouldOpenSettings ?? false) {
            await permissionsNotifier.openSettings(type);

            return permissionsNotifier.hasPermission(type);
          }

          return false;
        }

        final shouldRequest = await showSimpleBottomSheet<bool>(
          context: context,
          child: requestDialog,
        );

        if (shouldRequest ?? false) {
          await permissionsNotifier.requestPermission(type);
        }

        return false;
      };
    },
    [type, ref],
  );
}
