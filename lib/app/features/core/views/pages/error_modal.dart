// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/generated/assets.gen.dart';

class ErrorModal extends ConsumerWidget {
  ErrorModal({required this.error, super.key}) {
    Logger.error(error);
  }

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDebugInfo = ref.watch(envProvider.notifier).get<bool>(EnvVariable.SHOW_DEBUG_INFO);

    final errorInfo = switch (error) {
      Object _ when showDebugInfo => error.toString(),
      IONException(code: final int code) => context.i18n.error_general_error_code(code),
      _ => ''
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30.0.s, right: 30.0.s, top: 30.0.s),
              child: InfoCard(
                iconAsset: Assets.svg.actionWalletKeyserror,
                title: context.i18n.error_general_title,
                description: context.i18n.error_general_description(errorInfo),
              ),
            ),
            SizedBox(height: 24.0.s),
            ScreenSideOffset.small(
              child: Button(
                label: Text(context.i18n.button_try_again),
                mainAxisSize: MainAxisSize.max,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}

void showErrorModal(Object error) {
  showSimpleBottomSheet<void>(
    context: rootNavigatorKey.currentContext!,
    child: ErrorModal(error: error),
  );
}
