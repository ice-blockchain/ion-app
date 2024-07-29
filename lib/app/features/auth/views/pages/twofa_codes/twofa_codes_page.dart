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
import 'package:ice/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TwoFaCodesPage extends HookWidget {
  const TwoFaCodesPage({
    super.key,
    required this.twoFaTypes,
  });

  final Set<TwoFaType> twoFaTypes;

  @override
  Widget build(BuildContext context) {
    final formKey = useRef(GlobalKey<FormState>());
    final controllers = {
      for (final type in twoFaTypes) type: useTextEditingController(),
    };

    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.two_fa_title,
        description: context.i18n.two_fa_desc,
        icon: Assets.images.icons.iconWalletProtectVar1.icon(size: 36.0.s),
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
                      }).toList(),
                      Button(
                        onPressed: () {
                          if (!formKey.value.currentState!.validate()) {}
                        },
                        label: Text(context.i18n.button_confirm),
                        mainAxisSize: MainAxisSize.max,
                      ),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              )
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
