// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';
import 'package:ion/app/features/auth/views/pages/twofa_try_again/twofa_try_again_page.dart';
import 'package:ion/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class TwoFaCodesPage extends HookWidget {
  const TwoFaCodesPage({
    required this.twoFaTypes,
    super.key,
  });

  final Set<TwoFaType> twoFaTypes;

  @override
  Widget build(BuildContext context) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useRef(GlobalKey<FormState>());
    final controllers = {
      for (final type in twoFaTypes) type: useTextEditingController(),
    };

    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.two_fa_title,
        description: context.i18n.two_fa_desc,
        icon: Assets.svg.iconWalletProtectFill.icon(size: 36.0.s),
        children: [
          Column(
            children: [
              ScreenSideOffset.large(
                child: Form(
                  key: formKey.value,
                  child: Column(
                    children: [
                      SizedBox(height: 16.0.s),
                      ...twoFaTypes.map((twoFaType) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.0.s),
                          child: TwoFaCodeInput(
                            controller: controllers[twoFaType]!,
                            twoFaType: twoFaType,
                          ),
                        );
                      }),
                      Button(
                        onPressed: () {
                          if (formKey.value.currentState!.validate()) {
                            hideKeyboardAndCallOnce(
                              callback: () {
                                if (Random().nextBool() == true) {
                                  TwoFaSuccessRoute().push<void>(context);
                                } else {
                                  showSimpleBottomSheet<void>(
                                    context: context,
                                    child: const TwoFaTryAgainPage(),
                                  );
                                }
                              },
                            );
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
