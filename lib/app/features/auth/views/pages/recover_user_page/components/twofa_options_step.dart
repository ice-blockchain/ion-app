// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_option_selector.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class TwoFAOptionsStep extends HookConsumerWidget {
  const TwoFAOptionsStep({
    required this.onConfirm,
    super.key,
  });

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final optionsState = ref.watch(selectedTwoFAOptionsNotifierProvider);

    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.two_fa_title,
        description: context.i18n.two_fa_desc,
        icon: Assets.svg.iconWalletProtect.icon(size: 36.0.s),
        children: [
          Column(
            children: [
              ScreenSideOffset.large(
                child: Form(
                  key: formKey.value,
                  child: Column(
                    children: [
                      SizedBox(height: 16.0.s),
                      ...List.generate(
                        optionsState.optionsAmount,
                        (option) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.0.s),
                            child: TwoFaOptionSelector(
                              availableOptions: optionsState.availableOptions,
                              optionIndex: option + 1,
                              onSaved: (value) {
                                ref
                                    .read(selectedTwoFAOptionsNotifierProvider.notifier)
                                    .updateSelectedTwoFaOption(option, value);
                              },
                            ),
                          );
                        },
                      ),
                      Button(
                        onPressed: () {
                          final hasValues = optionsState.selectedValues.whereNotNull().isNotEmpty;
                          final isValidValues =
                              !optionsState.selectedValues.contains(TwoFaType.auth) ||
                                  optionsState.selectedValues.whereNotNull().length > 1;

                          if ((hasValues && isValidValues) ||
                              formKey.value.currentState!.validate()) {
                            onConfirm();
                          }
                        },
                        label: Text(context.i18n.button_confirm),
                        mainAxisSize: MainAxisSize.max,
                      ),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ScreenBottomOffset(
            child: const AuthFooter(),
          ),
        ],
      ),
    );
  }
}
