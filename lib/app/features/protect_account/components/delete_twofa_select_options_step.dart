// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/twofa_options/twofa_option_selector.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.dart';

class DeleteTwoFASelectOptionStep extends ConsumerWidget {
  const DeleteTwoFASelectOptionStep({
    required this.formKey,
    required this.twoFaType,
    required this.onConfirm,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TwoFaType twoFaType;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsState = ref.watch(deleteTwoFAOptionsNotifierProvider(twoFaType));

    return ScreenSideOffset.large(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              optionsState.optionsAmount,
              (option) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 22.0.s),
                  child: TwoFaOptionSelector(
                    availableOptions: optionsState.availableOptions,
                    optionIndex: option + 1,
                    onSaved: (value) {
                      ref
                          .read(deleteTwoFAOptionsNotifierProvider(twoFaType).notifier)
                          .updateSelectedTwoFaOption(option, value);
                    },
                  ),
                );
              },
            ),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_confirm),
              onPressed: () {
                formKey.currentState!.save();
                if (formKey.currentState!.validate()) {
                  onConfirm();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}