// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/auth/providers/local_passkey_creds_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_notifier.c.dart';
import 'package:ion/generated/assets.gen.dart';

class SuggestToCreateLocalPasskeyCredsPopup extends HookConsumerWidget {
  const SuggestToCreateLocalPasskeyCredsPopup({
    required this.username,
    super.key,
  });

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minSize = Size(56.0.s, 56.0.s);
    final localPasskeyCredsActionsState = ref.watch(localPasskeyCredsActionsNotifierProvider);
    final isProcessing = useState(false);

    ref.displayErrors(onboardingCompleteNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0.s, right: 30.0.s, top: 30.0.s),
          child: InfoCard(
            iconAsset: Assets.svg.actionWalletFaceid,
            title: context.i18n.new_passkey_creds_suggestion_title,
            description: context.i18n.new_passkey_creds_suggestion_desc,
          ),
        ),
        SizedBox(height: 38.0.s),
        ScreenSideOffset.small(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Button.compact(
                  type: ButtonType.outlined,
                  label: Text(context.i18n.button_cancel),
                  minimumSize: minSize,
                  disabled: isProcessing.value,
                  trailingIcon: isProcessing.value
                      ? const IONLoadingIndicator(
                          type: IndicatorType.dark,
                        )
                      : const SizedBox.shrink(),
                  onPressed: () async {
                    isProcessing.value = true;
                    try {
                      final isDelegationComplete =
                          ref.read(delegationCompleteProvider).valueOrNull.falseOrValue;
                      if (!isDelegationComplete) {
                        await ref.read(onboardingCompleteNotifierProvider.notifier).addDelegation(
                              ({
                                required onPasskeyFlow,
                                required onPasswordFlow,
                                required onBiometricsFlow,
                              }) =>
                                  onPasskeyFlow(),
                            );
                      }
                      await ref
                          .read(localPasskeyCredsActionsNotifierProvider.notifier)
                          .rejectToCreateLocalPasskeyCreds(username: username);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } finally {
                      isProcessing.value = false;
                    }
                  },
                ),
              ),
              SizedBox(
                width: 16.0.s,
              ),
              Expanded(
                child: Button.compact(
                  label: Text(context.i18n.button_continue),
                  minimumSize: minSize,
                  disabled: localPasskeyCredsActionsState.isLoading,
                  trailingIcon: localPasskeyCredsActionsState.isLoading
                      ? const IONLoadingIndicator()
                      : const SizedBox.shrink(),
                  onPressed: () async {
                    await ref
                        .read(localPasskeyCredsActionsNotifierProvider.notifier)
                        .createLocalPasskeyCreds(username: username);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
