// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/create_local_creds_notifier.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion_identity_client/ion_identity.dart';

class CreateLocalCredsPromptDialog extends HookConsumerWidget {
  const CreateLocalCredsPromptDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenCreateLocalCredsSuccess(ref);

    return Column(
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.create_local_creds_prompt_dialog_title),
        ),
        ScreenSideOffset.small(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Button(
                label: Text(context.i18n.create_local_creds_prompt_dialog_create_button),
                onPressed: () {
                  _createLocalCreds(ref);
                },
              ),
              SizedBox(height: 16.0.s),
              Button(
                type: ButtonType.outlined,
                label: Text(context.i18n.create_local_creds_prompt_dialog_skip_button),
                onPressed: () {
                  _navigateNext(ref);
                },
              ),
            ],
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }

  Future<void> _createLocalCreds(WidgetRef ref) async {
    await guardPasskeyDialog(
      ref.context,
      (child) => RiverpodVerifyIdentityRequestBuilder(
        provider: createLocalCredsNotifierProvider,
        requestWithVerifyIdentity: (OnVerifyIdentity<CredentialResponse> onVerifyIdentity) {
          ref.read(createLocalCredsNotifierProvider.notifier).createLocalCreds(onVerifyIdentity);
        },
        child: child,
      ),
    );
  }

  void _listenCreateLocalCredsSuccess(WidgetRef ref) {
    ref.listenSuccess(createLocalCredsNotifierProvider, (result) {
      _navigateNext(ref);
    });
  }

  void _navigateNext(WidgetRef ref) {
    Navigator.of(ref.context).pop();
    final onboardingComplete = ref.read(onboardingCompleteProvider).valueOrNull;
    if (onboardingComplete != null && onboardingComplete) {
      FeedRoute().push<void>(ref.context);
    } else {
      FillProfileRoute().push<void>(ref.context);
    }
  }
}
