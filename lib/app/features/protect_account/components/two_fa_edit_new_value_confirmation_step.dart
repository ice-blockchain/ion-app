// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_code_input.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_try_again_page.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/edit_twofa_notifier.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion_identity_client/ion_identity.dart';

class TwoFaEditConfirmNewValueStep extends HookConsumerWidget {
  const TwoFaEditConfirmNewValueStep({
    required this.newValue,
    required this.twoFaType,
    required this.onNext,
    super.key,
  });

  final String newValue;
  final TwoFaType twoFaType;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final theme = context.theme;
    final formKey = useRef(GlobalKey<FormState>());
    final codeController = useTextEditingController.fromValue(TextEditingValue.empty);

    final editTwoFaCodeNotifier = ref.watch(editTwoFaCodeNotifierProvider);

    ref
      ..listenError(
        editTwoFaCodeNotifierProvider,
        (e) {
          if (e.runtimeType == InvalidTwoFaCodeException) {
            showSimpleBottomSheet<void>(
              context: ref.context,
              child: const TwoFaTryAgainPage(),
            );
          }
        },
      )
      ..displayErrors(
        editTwoFaCodeNotifierProvider,
        excludedExceptions: {InvalidTwoFaCodeException},
      );

    return Form(
      key: formKey.value,
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return ScreenSideOffset.large(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8.0.s),
                Text(
                  newValue,
                  style: theme.appTextThemes.body,
                ),
                if (isKeyboardVisible) SizedBox(height: 58.0.s),
                const Spacer(),
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 22.0.s),
                  child: TwoFaCodeInput(
                    controller: codeController,
                    twoFaType: twoFaType,
                  ),
                ),
                const Spacer(),
                ScreenBottomOffset(
                  margin: 48.0.s,
                  child: Button(
                    mainAxisSize: MainAxisSize.max,
                    label: Text(locale.button_confirm),
                    trailingIcon:
                        editTwoFaCodeNotifier.isLoading ? const IONLoadingIndicator() : null,
                    disabled: editTwoFaCodeNotifier.isLoading,
                    onPressed: () => _validateAndProceed(
                      ref,
                      formKey.value,
                      codeController.text,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _validateAndProceed(
    WidgetRef ref,
    GlobalKey<FormState>? formKey,
    String code,
  ) {
    final isFormValid = formKey?.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }

    final twoFAType = switch (twoFaType) {
      TwoFaType.email => TwoFAType.email(code),
      TwoFaType.sms => TwoFAType.sms(code),
      _ => null,
    };
    if (twoFAType == null) {
      return;
    }

    ref.listenSuccessManual(editTwoFaCodeNotifierProvider, (_) => _onSuccess(ref));
    ref.read(editTwoFaCodeNotifierProvider.notifier).editTwoFa(twoFAType);
  }

  Future<void> _onSuccess(WidgetRef ref) async {
    ref.invalidate(securityAccountControllerProvider);

    if (!ref.context.mounted) {
      return;
    }

    onNext();
  }
}
