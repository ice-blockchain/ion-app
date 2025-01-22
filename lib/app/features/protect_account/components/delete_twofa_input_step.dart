// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/warning_card.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_code_input.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_try_again_page.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_email_provider.c.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_phone_provider.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/delete_twofa_notifier.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/request_twofa_code_notifier.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion_identity_client/ion_identity.dart';

class DeleteTwoFAInputStep extends HookConsumerWidget {
  const DeleteTwoFAInputStep({
    required this.twoFaToDelete,
    required this.twoFaTypes,
    required this.onDeleteSuccess,
    super.key,
  });

  final TwoFaType twoFaToDelete;
  final List<TwoFaType> twoFaTypes;
  final VoidCallback onDeleteSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRequesting = ref.watch(
      requestTwoFaCodeNotifierProvider.select(
        (value) => value.isLoading,
      ),
    );

    final formKey = useRef(GlobalKey<FormState>());

    final controllers = {
      for (final type in twoFaTypes)
        type: useTextEditingController.fromValue(TextEditingValue.empty),
    };

    _listenDeleteTwoFAResult(ref);

    return ScreenSideOffset.large(
      child: Form(
        key: formKey.value,
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemCount: twoFaTypes.length,
              itemBuilder: (context, index) {
                final twoFaType = twoFaTypes[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 22.0.s),
                  child: TwoFaCodeInput(
                    controller: controllers[twoFaType]!,
                    twoFaType: twoFaType,
                    onRequestCode: () async {
                      await guardPasskeyDialog(
                        ref.context,
                        (child) => RiverpodVerifyIdentityRequestBuilder(
                          provider: requestTwoFaCodeNotifierProvider,
                          requestWithVerifyIdentity:
                              (OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity) {
                            ref.read(requestTwoFaCodeNotifierProvider.notifier).requestTwoFaCode(
                                  twoFaType,
                                  onVerifyIdentity,
                                );
                          },
                          child: child,
                        ),
                      );
                    },
                    isSending: isRequesting,
                  ),
                );
              },
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WarningCard(
                      text: context.i18n.two_fa_warning,
                    ),
                    SizedBox(
                      height: 24.0.s,
                    ),
                    Button(
                      mainAxisSize: MainAxisSize.max,
                      label: Text(context.i18n.button_confirm),
                      onPressed: () {
                        if (formKey.value.currentState!.validate()) {
                          _onConfirm(ref, controllers);
                        }
                      },
                    ),
                    SizedBox(
                      height: 48.0.s,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm(
    WidgetRef ref,
    Map<TwoFaType, TextEditingController> controllers,
  ) {
    guardPasskeyDialog(
      ref.context,
      (child) => RiverpodVerifyIdentityRequestBuilder(
        provider: deleteTwoFANotifierProvider,
        requestWithVerifyIdentity: (
          OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
        ) async {
          final twoFaValue = await _getTwoFaValue(ref, twoFaToDelete);
          await ref.read(deleteTwoFANotifierProvider.notifier).deleteTwoFa(
            TwoFaTypeAdapter(twoFaToDelete, twoFaValue).twoFAType,
            onVerifyIdentity,
            [
              for (final controller in controllers.entries)
                TwoFaTypeAdapter(controller.key, controller.value.text).twoFAType,
            ],
          );
        },
        child: child,
      ),
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
        onDeleteSuccess();
      }
    });
  }

  Future<String?> _getTwoFaValue(WidgetRef ref, TwoFaType type) async {
    return switch (type) {
      TwoFaType.email => ref.read(linkedEmailProvider.future),
      TwoFaType.sms => ref.read(linkedPhoneProvider.future),
      TwoFaType.auth => null,
    };
  }
}
