// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_notifier.c.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/ui_event_queue/ui_event_queue_notifier.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class ShowLinkNewDeviceDialogEvent extends UiEvent {
  const ShowLinkNewDeviceDialogEvent();

  @override
  void performAction(BuildContext context) {
    showSimpleBottomSheet<void>(
      context: context,
      isDismissible: false,
      child: const LinkNewDeviceDialog(),
    );
  }
}

class LinkNewDeviceDialog extends HookConsumerWidget {
  const LinkNewDeviceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = context.theme.appTextThemes;
    final colors = context.theme.appColors;

    final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
    useOnInit(
      () {
        if (delegationComplete) {
          Navigator.of(ref.context).pop();
        }
      },
      [delegationComplete],
    );

    final state = ref.watch(onboardingCompleteNotifierProvider);
    ref.displayErrors(onboardingCompleteNotifierProvider);

    return ScreenSideOffset.medium(
      child: Column(
        children: [
          SizedBox(height: 48.0.s),
          Assets.svg.actionLoginLinkaccount.icon(size: 80.0.s),
          SizedBox(height: 6.0.s),
          Text(
            context.i18n.auth_link_new_device_title,
            style: textStyles.title,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0.s),
          Text(
            context.i18n.auth_link_new_device_description,
            style: textStyles.body2.copyWith(color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28.0.s),
          Button(
            minimumSize: Size(double.infinity, 56.0.s),
            disabled: state.isLoading,
            trailingIcon: state.isLoading ? const IONLoadingIndicator() : const SizedBox.shrink(),
            label: Text(context.i18n.auth_link_new_device_link_button),
            onPressed: () => _addDelegation(ref),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }

  Future<void> _addDelegation(WidgetRef ref) async {
    await guardPasskeyDialog(
      ref.context,
      (child) => RiverpodVerifyIdentityRequestBuilder(
        requestWithVerifyIdentity: (OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity) {
          ref.read(onboardingCompleteNotifierProvider.notifier).addDelegation(onVerifyIdentity);
        },
        provider: onboardingCompleteNotifierProvider,
        child: child,
      ),
    );
  }
}
