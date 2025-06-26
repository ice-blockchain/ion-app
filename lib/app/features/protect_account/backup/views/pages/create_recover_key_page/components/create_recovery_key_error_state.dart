// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/protect_account/backup/providers/create_recovery_key_action_notifier.r.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class CreateRecoveryKeyErrorState extends ConsumerWidget {
  const CreateRecoveryKeyErrorState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    return Expanded(
      child: ScreenSideOffset.large(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 62.0.s),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.tertararyBackground,
                    border: Border.all(color: colors.onTerararyFill),
                    borderRadius: BorderRadius.circular(16.0.s),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0.s),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Assets.svg.walletIconWalletLoadingerror.icon(size: 48.0.s),
                        SizedBox(height: 10.0.s),
                        Text(
                          locale.protect_account_create_recovery_error,
                          style: context.theme.appTextThemes.caption2
                              .copyWith(color: colors.onTertararyBackground),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(locale.button_retry),
              onPressed: () => guardPasskeyDialog(
                context,
                (child) => RiverpodVerifyIdentityRequestBuilder(
                  provider: createRecoveryKeyActionNotifierProvider,
                  requestWithVerifyIdentity:
                      (OnVerifyIdentity<CredentialResponse> onVerifyIdentity) {
                    ref
                        .read(createRecoveryKeyActionNotifierProvider.notifier)
                        .createRecoveryCredentials(onVerifyIdentity);
                  },
                  child: child,
                ),
              ),
            ),
            SizedBox(height: 16.0.s),
          ],
        ),
      ),
    );
  }
}
