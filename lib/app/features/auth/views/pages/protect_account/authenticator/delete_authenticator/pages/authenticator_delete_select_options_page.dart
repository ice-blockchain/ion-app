import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_steps.dart';
import 'package:ice/app/features/auth/views/pages/twofa_options/twofa_option_selector.dart';
import 'package:ice/app/router/app_routes.dart';

class AuthenticatorDeleteSelectOptionsPage extends HookConsumerWidget {
  const AuthenticatorDeleteSelectOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAmount = useState(Random().nextInt(2) + 1);
    final formKey = useRef(GlobalKey<FormState>());

    final selectedValues = {
      for (int i = 0; i < optionsAmount.value; i++) i: useState<TwoFaType?>(null)
    };
    final availableOptions = useState<Set<TwoFaType>>(TwoFaType.values.toSet());

    return ScreenSideOffset.large(
      child: Form(
        key: formKey.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              optionsAmount.value,
              (option) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 22.0.s),
                  child: TwoFaOptionSelector(
                    availableOptions: selectedValues[option]?.value != null
                        ? {selectedValues[option]!.value!, ...availableOptions.value}
                        : availableOptions.value,
                    optionIndex: option + 1,
                    onSaved: (value) {
                      if (selectedValues[option]?.value != null) {
                        availableOptions.value = {
                          ...availableOptions.value,
                          selectedValues[option]!.value!
                        };
                      }
                      selectedValues[option]?.value = value;
                      availableOptions.value = {...availableOptions.value}..remove(value);
                    },
                  ),
                );
              },
            ),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_confirm),
              onPressed: () {
                if (formKey.value.currentState!.validate()) {
                  final extra = selectedValues.values
                      .map((selectedValue) => selectedValue.value)
                      .where((TwoFaType? value) => value != null)
                      .cast<TwoFaType>()
                      .toSet();

                  AuthenticatorDeleteRoute(
                    $extra: extra,
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
