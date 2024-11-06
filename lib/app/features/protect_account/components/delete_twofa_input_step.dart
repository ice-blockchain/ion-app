// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';
import 'package:ion/app/features/auth/views/pages/twofa_try_again/twofa_try_again_page.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/delete_twofa_notifier.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/request_twofa_code_notifier.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion_identity_client/ion_identity.dart';

class DeleteTwoFAInputStep extends HookConsumerWidget {
  const DeleteTwoFAInputStep({
    required this.twoFaTypes,
    required this.onDeleteSuccess,
    super.key,
  });

  final List<TwoFaType> twoFaTypes;
  final VoidCallback onDeleteSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRequesting = ref.watch(requestTwoFaCodeNotifierProvider).isLoading;

    final formKey = useRef(GlobalKey<FormState>());

    final controllers = {
      for (final type in twoFaTypes)
        type: useTextEditingController.fromValue(TextEditingValue.empty),
    };

    _listenDeleteTwoFAResult(context, ref);

    return ScreenSideOffset.large(
      child: Form(
        key: formKey.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                for (final twoFaType in twoFaTypes)
                  Padding(
                    padding: EdgeInsets.only(bottom: 22.0.s),
                    child: TwoFaCodeInput(
                      controller: controllers[twoFaType]!,
                      twoFaType: twoFaType,
                      onRequestCode: () {
                        ref
                            .read(requestTwoFaCodeNotifierProvider.notifier)
                            .requestTwoFaCode(twoFaType);
                      },
                      isSending: isRequesting,
                    ),
                  ),
              ],
            ),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_confirm),
              onPressed: () {
                final isFormValid = formKey.value.currentState!.validate();
                if (!isFormValid) {
                  return;
                }

                _onConfirm(ref, context, controllers);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm(
    WidgetRef ref,
    BuildContext context,
    Map<TwoFaType, TextEditingController> controllers,
  ) {
    ref.read(deleteTwoFANotifierProvider.notifier).deleteTwoFa(
      const TwoFAType.authenticator(),
      [
        for (final e in controllers.entries) TwoFaTypeAdapter(e.key, e.value.text).twoFAType,
      ],
    );
  }

  void _listenDeleteTwoFAResult(BuildContext context, WidgetRef ref) {
    ref.listen(deleteTwoFANotifierProvider, (prev, next) {
      if (prev?.isLoading != true) {
        return;
      }

      if (next.hasError) {
        showSimpleBottomSheet<void>(
          context: context,
          child: const TwoFaTryAgainPage(),
        );
        return;
      }

      if (next.hasValue) {
        onDeleteSuccess();
      }
    });
  }
}
