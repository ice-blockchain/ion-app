// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_code_input.dart';
import 'package:ion/app/features/components/verify_identity/hooks/use_on_get_password.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/request_twofa_code_notifier.c.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/features/user/providers/user_verify_identity_provider.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class TwoFAInputStep extends HookConsumerWidget {
  const TwoFAInputStep({
    required this.recoveryIdentityKeyName,
    required this.onContinuePressed,
    super.key,
  });

  final String recoveryIdentityKeyName;
  final void Function(Map<TwoFaType, String>) onContinuePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRequesting = ref.watch(
      requestTwoFaCodeNotifierProvider.select(
        (value) => value.isLoading,
      ),
    );

    final twoFaTypes = ref.watch(selectedTwoFaOptionsProvider);

    final formKey = useRef(GlobalKey<FormState>());
    final controllers = {
      for (final type in twoFaTypes) type: useTextEditingController(),
    };

    final onGetPassword = useOnGetPassword(context);

    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.two_fa_title,
        description: context.i18n.two_fa_desc,
        icon: Assets.svg.iconWalletProtectFill.icon(size: 36.0.s),
        children: [
          Column(
            children: [
              ScreenSideOffset.large(
                child: Form(
                  key: formKey.value,
                  child: Column(
                    children: [
                      SizedBox(height: 16.0.s),
                      ...[
                        for (final twoFaType in twoFaTypes)
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.0.s),
                            child: TwoFaCodeInput(
                              controller: controllers[twoFaType]!,
                              twoFaType: twoFaType,
                              onRequestCode: () async {
                                await ref
                                    .read(requestTwoFaCodeNotifierProvider.notifier)
                                    .requestRecoveryTwoFaCode(twoFaType, recoveryIdentityKeyName, ({
                                  required OnPasswordFlow<GenerateSignatureResponse> onPasswordFlow,
                                  required OnPasskeyFlow<GenerateSignatureResponse> onPasskeyFlow,
                                }) {
                                  return ref.watch(
                                    verifyUserIdentityProvider(
                                      onGetPassword: onGetPassword,
                                      onPasswordFlow: onPasswordFlow,
                                      onPasskeyFlow: onPasskeyFlow,
                                    ).future,
                                  );
                                });
                              },
                              isSending: isRequesting,
                            ),
                          ),
                      ],
                      Button(
                        onPressed: () {
                          if (formKey.value.currentState!.validate()) {
                            _onConfirm(ref, controllers);
                          }
                        },
                        label: Text(context.i18n.button_confirm),
                        mainAxisSize: MainAxisSize.max,
                      ),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ScreenBottomOffset(
            child: const AuthFooter(),
          ),
        ],
      ),
    );
  }

  void _onConfirm(WidgetRef ref, Map<TwoFaType, TextEditingController> controllers) {
    onContinuePressed({
      for (final entry in controllers.entries) entry.key: entry.value.text,
    });
  }
}
