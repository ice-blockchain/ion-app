// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/login_action_notifier.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ion/app/features/auth/views/pages/create_local_creds_prompt_dialog/create_local_creds_prompt_dialog.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyNameController = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>());

    final authState = ref.watch(authProvider);
    final loginActionState = ref.watch(loginActionNotifierProvider);

    ref.displayErrors(loginActionNotifierProvider);

    _listenLoginSuccess(ref);

    return Form(
      key: formKey.value,
      child: Column(
        children: [
          IdentityKeyNameInput(
            errorText: loginActionState.error?.toString(),
            controller: identityKeyNameController,
            scrollPadding: EdgeInsets.only(bottom: 190.0.s),
          ),
          SizedBox(height: 16.0.s),
          Button(
            disabled: loginActionState.isLoading,
            trailingIcon: loginActionState.isLoading ||
                    (authState.valueOrNull?.hasAuthenticated).falseOrValue
                ? const IONLoadingIndicator()
                : Assets.svg.iconButtonNext.icon(color: context.theme.appColors.onPrimaryAccent),
            onPressed: () {
              if (formKey.value.currentState!.validate()) {
                _showPasskeyDialog(ref, identityKeyNameController.text);
              }
            },
            label: Text(context.i18n.button_continue),
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }

  Future<void> _showPasskeyDialog(
    WidgetRef ref,
    String identityKeyName,
  ) {
    return guardPasskeyDialog(
      ref.context,
      (child) => RiverpodVerifyIdentityRequestBuilder(
        provider: loginActionNotifierProvider,
        requestWithVerifyIdentity: (_) {
          ref.read(loginActionNotifierProvider.notifier).signIn(keyName: identityKeyName);
        },
        child: child,
      ),
    );
  }

  void _listenLoginSuccess(WidgetRef ref) {
    ref.listenSuccess(loginActionNotifierProvider, (result) {
      if (result?.localCredsUsed ?? false) {
        _navigateNext(ref);
      } else {
        _showCreateLocalCredsPromptDialog(ref);
      }
    });
  }

  void _navigateNext(WidgetRef ref) {
    final onboardingComplete = ref.read(onboardingCompleteProvider).valueOrNull;
    if (onboardingComplete != null && onboardingComplete) {
      FeedRoute().push<void>(ref.context);
    } else {
      FillProfileRoute().push<void>(ref.context);
    }
  }

  void _showCreateLocalCredsPromptDialog(WidgetRef ref) {
    showSimpleBottomSheet<void>(
      context: ref.context,
      child: const CreateLocalCredsPromptDialog(),
    );
  }
}
