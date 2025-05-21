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
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class ErrorModal extends ConsumerWidget {
  ErrorModal({required this.error, super.key}) {
    Logger.error(error);
  }

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDebugInfo = ref.watch(envProvider.notifier).get<bool>(EnvVariable.SHOW_DEBUG_INFO);

    final title = switch (error) {
      final IONIdentityException identityException => identityException.title(context),
      _ => context.i18n.error_general_title,
    };

    final description = switch (error) {
      final PaymentNoDestinationException ex =>
        context.i18n.error_payment_no_destination_description(ex.abbreviation),
      final IONIdentityException identityException => identityException.description(context),
      Object _ when showDebugInfo => error.toString(),
      IONException(code: final int code) =>
        context.i18n.error_general_description(context.i18n.error_general_error_code(code)),
      _ => context.i18n.error_general_description('')
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 30.0.s, end: 30.0.s, top: 30.0.s),
              child: InfoCard(
                title: title,
                description: description,
                iconAsset: Assets.svg.actionWalletKeyserror,
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

void showErrorModal(BuildContext context, Object error) {
  showSimpleBottomSheet<void>(
    context: context,
    child: ErrorModal(error: error),
  );
}
