// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_try_again_page.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/features/protect_account/components/twofa_input_step.dart';
import 'package:ion/app/features/protect_account/components/twofa_step_scaffold.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_email_provider.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/request_twofa_code_notifier.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class EmailEditTwoFaInputStep extends ConsumerWidget {
  const EmailEditTwoFaInputStep({
    required this.email,
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final String email;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    return TwoFAStepScaffold(
      headerTitle: locale.two_fa_edit_email_title,
      headerDescription: locale.two_fa_edit_email_options_description,
      headerIcon: Assets.svgIcon2faEmailauth.icon(size: 36.0.s),
      onBackPress: onPrevious,
      child: TwoFAInputStep(
        onConfirm: (controllers) => _onConfirm(ref, controllers),
        twoFaTypes: ref.watch(selectedTwoFaOptionsProvider).toList(),
      ),
    );
  }

  Future<void> _onConfirm(
    WidgetRef ref,
    Map<TwoFaType, String> controllers,
  ) async {
    _listenRequestTwoFAResult(ref);
    final linkedEmail = await ref.read(linkedEmailProvider.future);
    await ref.read(requestTwoFaCodeNotifierProvider.notifier).requestEditTwoFaCode(
          TwoFAType.email(email),
          verificationCodes: [
            for (final controller in controllers.entries)
              TwoFaTypeAdapter(controller.key, controller.value).twoFAType,
          ],
          oldTwoFaValue: linkedEmail,
        );
  }

  void _listenRequestTwoFAResult(WidgetRef ref) {
    ref.listenManual(requestTwoFaCodeNotifierProvider, (prev, next) {
      if (prev?.isLoading != true) {
        return;
      }

      if (next.hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSimpleBottomSheet<void>(
            context: ref.context,
            child: const TwoFaTryAgainPage(),
          );
        });
        return;
      }

      if (next.hasValue) {
        onNext();
      }
    });
  }
}
