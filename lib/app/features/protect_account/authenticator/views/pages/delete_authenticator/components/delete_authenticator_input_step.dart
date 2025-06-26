// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_try_again_page.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/features/protect_account/components/twofa_input_step.dart';
import 'package:ion/app/features/protect_account/components/twofa_step_scaffold.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/delete_twofa_notifier.r.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.m.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteAuthenticatorInputStep extends ConsumerWidget {
  const DeleteAuthenticatorInputStep({
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    _listenDeleteTwoFAResult(ref);

    return TwoFAStepScaffold(
      headerTitle: locale.authenticator_delete_title,
      headerDescription: locale.authenticator_delete_description,
      headerIcon: Assets.svg.iconWalletProtectFill.icon(size: 36.0.s),
      onBackPress: onPrevious,
      contentPadding: 8.0.s,
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
    await ref.read(deleteTwoFANotifierProvider.notifier).deleteTwoFa(
      TwoFaTypeAdapter(TwoFaType.auth).twoFAType,
      [
        for (final controller in controllers.entries)
          TwoFaTypeAdapter(controller.key, controller.value).twoFAType,
      ],
    );
  }

  void _listenDeleteTwoFAResult(WidgetRef ref) {
    ref.listen(deleteTwoFANotifierProvider, (prev, next) {
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
