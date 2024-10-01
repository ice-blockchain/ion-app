// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/features/auth/views/pages/twofa_options/mock_data/mock.dart';
import 'package:ice/app/features/auth/views/pages/twofa_options/twofa_option_selector.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TwoFaOptionsPage extends HookWidget {
  const TwoFaOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final optionsNumber = useState(get2FAOptionsNumber());
    final formKey = useRef(GlobalKey<FormState>());
    final selectedValues = {
      for (int i = 0; i < optionsNumber.value; i++) i: useState<TwoFaType?>(null),
    };
    final availableOptions = useState<Set<TwoFaType>>(TwoFaType.values.toSet());

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
                      ...List.generate(optionsNumber.value, (i) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.0.s),
                          child: TwoFaOptionSelector(
                            availableOptions: selectedValues[i]?.value != null
                                ? {selectedValues[i]!.value!, ...availableOptions.value}
                                : availableOptions.value,
                            optionIndex: i + 1,
                            onSaved: (value) {
                              if (selectedValues[i]?.value != null) {
                                availableOptions.value = {
                                  ...availableOptions.value,
                                  selectedValues[i]!.value!,
                                };
                              }
                              selectedValues[i]?.value = value;
                              availableOptions.value = {...availableOptions.value}..remove(value);
                            },
                          ),
                        );
                      }),
                      Button(
                        onPressed: () {
                          if (formKey.value.currentState!.validate()) {
                            final extra = selectedValues.values
                                .map((selectedValue) => selectedValue.value)
                                .where((TwoFaType? value) => value != null)
                                .cast<TwoFaType>()
                                .toSet();
                            TwoFaCodesRoute($extra: extra).push<void>(context);
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
