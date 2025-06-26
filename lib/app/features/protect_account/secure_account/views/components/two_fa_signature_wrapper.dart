// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/two_fa_signature_wrapper_notifier.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion_identity_client/ion_identity.dart';

class TwoFaSignatureWrapper extends HookConsumerWidget {
  const TwoFaSignatureWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      twoFaSignatureWrapperNotifierProvider,
      (_, next) {
        if (next.isLoading || next.hasError || !next.hasValue || !context.mounted) return;
        final failedAction = next.valueOrNull;
        if (failedAction == null) return;

        guardPasskeyDialog(
          rootNavigatorKey.currentContext!,
          (child) => HookVerifyIdentityRequestBuilder(
            requestWithVerifyIdentity:
                (OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity) => ref
                    .read(twoFaSignatureWrapperNotifierProvider.notifier)
                    .retryWithVerifyIdentity(
                      failedAction,
                      onVerifyIdentity,
                    ),
            child: child,
          ),
        );
      },
    );

    return child;
  }
}
