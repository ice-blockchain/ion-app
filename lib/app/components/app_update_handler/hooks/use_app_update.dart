// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/config/providers/force_update_provider.c.dart';
import 'package:ion/app/features/core/model/app_update_type.dart';
import 'package:ion/app/features/core/views/pages/app_update_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

void useAppUpdate(WidgetRef ref) {
  final isUpdateModalVisible = useState(false);
  final forceUpdateState = ref.watch(forceUpdateProvider);

  useEffect(
    () {
      if (forceUpdateState.shouldShowUpdateModal && !isUpdateModalVisible.value) {
        isUpdateModalVisible.value = true;

        showSimpleBottomSheet<void>(
          isDismissible: false,
          context: rootNavigatorKey.currentContext!,
          child: const AppUpdateModal(
            appUpdateType: AppUpdateType.updateRequired,
          ),
        );
      } else if (!forceUpdateState.shouldShowUpdateModal && isUpdateModalVisible.value) {
        Navigator.of(rootNavigatorKey.currentContext!).pop();
        isUpdateModalVisible.value = false;
      }
      return null;
    },
    [forceUpdateState],
  );
}
