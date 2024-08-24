import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/delete_authenticator/components/two_fa_options_selector_list.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_steps.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/providers/selected_two_fa_types_provider.dart';
import 'package:ice/app/router/app_routes.dart';

class AuthenticatorDeleteSelectOptionsPage extends HookConsumerWidget {
  const AuthenticatorDeleteSelectOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTwoFaTypesNotifier = ref.read(selectedTwoFaTypesNotifierProvider.notifier);
    final optionsAmount = useState(Random().nextInt(2) + 1);
    final formKey = useRef(GlobalKey<FormState>());

    return ScreenSideOffset.large(
      child: Form(
        key: formKey.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TwoFaOptionSelectorList(
              optionsAmount: optionsAmount.value,
              onOptionSaved: (value) {
                if (value != null) {
                  selectedTwoFaTypesNotifier.select(value);
                }
              },
            ),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_confirm),
              onPressed: () {
                if (formKey.value.currentState!.validate()) {
                  AuthenticatorDeleteRoute(
                    step: AuthenticatorDeleteSteps.input,
                  ).push<void>(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
