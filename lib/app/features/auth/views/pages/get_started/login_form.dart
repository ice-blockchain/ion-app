import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/generated/assets.gen.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyNameController = useTextEditingController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useRef(GlobalKey<FormState>());
    final authState = ref.watch(authProvider);

    return Form(
      key: formKey.value,
      child: Column(
        children: [
          IdentityKeyNameInput(
            controller: identityKeyNameController,
            scrollPadding: EdgeInsets.only(bottom: 190.0.s),
          ),
          SizedBox(height: 16.0.s),
          Button(
            disabled: authState is AuthenticationLoading,
            trailingIcon: authState is AuthenticationLoading
                ? const IceLoadingIndicator()
                : Assets.images.icons.iconButtonNext.icon(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
            onPressed: () {
              if (formKey.value.currentState!.validate()) {
                hideKeyboardAndCallOnce(
                  callback: () => ref
                      .read(authProvider.notifier)
                      .signIn(keyName: identityKeyNameController.text),
                );
              }
            },
            label: Text(context.i18n.button_continue),
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }
}
