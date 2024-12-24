// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/app_update_handler/hooks/use_app_update.dart';
import 'package:ion/app/features/core/model/app_update_type.dart';
import 'package:ion/app/features/core/views/pages/app_update_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class AppUpdateHandler extends HookConsumerWidget {
  const AppUpdateHandler({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModalShown = useAppUpdate(ref);

    if (!isModalShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSimpleBottomSheet<void>(
          isDismissible: false,
          context: rootNavigatorKey.currentContext!,
          child: const AppUpdateModal(
            appUpdateType: AppUpdateType.updateRequired,
          ),
        );
      });
    }

    return child;
  }
}
