// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/force_update/model/app_update_type.dart';
import 'package:ion/app/features/force_update/providers/force_update_provider.c.dart';
import 'package:ion/app/features/force_update/view/pages/app_update_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

void useAppUpdate(WidgetRef ref) {
  final isUpdateModalVisible = useState(false);
  final needForceUpdate = ref.watch(forceUpdateProvider);

  useEffect(
    () {
      if (needForceUpdate.falseOrValue && !isUpdateModalVisible.value) {
        isUpdateModalVisible.value = true;

        showSimpleBottomSheet<void>(
          isDismissible: false,
          context: rootNavigatorKey.currentContext!,
          child: const AppUpdateModal(
            appUpdateType: AppUpdateType.updateRequired,
          ),
        );
      }
      return null;
    },
    [needForceUpdate],
  );
}
