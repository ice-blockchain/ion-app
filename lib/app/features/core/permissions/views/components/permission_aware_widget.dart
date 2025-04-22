// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class PermissionAwareWidget extends ConsumerWidget {
  const PermissionAwareWidget({
    required this.permissionType,
    required this.builder,
    required this.onGranted,
    required this.requestDialog,
    this.settingsDialog,
    this.requestId = 'default',
    this.onGrantedPredicate = _defaultPredicate,
    super.key,
  });

  final Permission permissionType;
  final Widget Function(BuildContext context, VoidCallback onPressed) builder;
  final VoidCallback onGranted;
  final Widget requestDialog;
  final Widget? settingsDialog;
  final String requestId;

  /// A predicate function that determines if onGranted should be executed.
  ///
  /// This function will be called before executing onGranted.
  /// If it returns true, onGranted will be executed; otherwise, it won't.
  /// By default, it always returns true.
  final bool Function() onGrantedPredicate;

  /// Default predicate that always returns true.
  static bool _defaultPredicate() => true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionKey = permissionType.name;
    final activeRequestId = ref.watch(activePermissionRequestIdProvider(permissionKey));
    final hasPermission = ref.watch(hasPermissionProvider(permissionType));

    ref.listen<bool>(
      hasPermissionProvider(permissionType),
      (previous, next) {
        if (next && _shouldExecuteOnGranted(context, activeRequestId)) {
          onGranted();
        }
      },
    );

    return builder(
      context,
      () {
        if (hasPermission && onGrantedPredicate()) {
          onGranted();
        } else {
          _handlePermissionRequest(context, ref, permissionKey);
        }
      },
    );
  }

  /// Determines if the onGranted callback should be executed based on context and request state.
  ///
  /// Checks:
  /// - The context is still mounted
  /// - Either there's no active request ID or the active request ID matches this widget's request ID
  /// - The onGrantedPredicate returns true
  bool _shouldExecuteOnGranted(BuildContext context, String? activeRequestId) {
    return context.mounted &&
        (activeRequestId == null || activeRequestId == requestId) &&
        onGrantedPredicate();
  }

  Future<void> _handlePermissionRequest(
    BuildContext context,
    WidgetRef ref,
    String permissionKey,
  ) async {
    ref.read(activePermissionRequestIdProvider(permissionKey).notifier).requestId = requestId;

    final isPermanentlyDenied = ref.read(isPermanentlyDeniedProvider(permissionType));
    final permissionsNotifier = ref.read(permissionsProvider.notifier);
    final permissionStrategy = ref.read(permissionStrategyProvider(permissionType));

    if (!context.mounted) return;

    if (isPermanentlyDenied) {
      final shouldOpenSettings = settingsDialog != null
          ? await showSimpleBottomSheet<bool>(
              context: context,
              child: settingsDialog!,
            )
          : true;
      if (shouldOpenSettings ?? false) {
        await permissionStrategy.openSettings();
      }
    } else {
      final shouldRequest = await showSimpleBottomSheet<bool>(
        context: context,
        child: requestDialog,
      );
      if (shouldRequest ?? false) {
        await permissionsNotifier.requestPermission(permissionType);
      }
    }
  }
}
