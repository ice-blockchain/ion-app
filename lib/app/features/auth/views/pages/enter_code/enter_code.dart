import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/code_fields/code_fields.dart';
import 'package:ice/app/features/auth/views/components/terms_privacy/terms_privacy.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/services/keyboard/keyboard.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCode extends IceSimplePage {
  const EnterCode(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    const String phoneNumber = '+101234567890';
    const String code = '1111';

    final TextEditingController codeController = useTextEditingController();
    final StreamController<ErrorAnimationType> errorController =
        useStreamController<ErrorAnimationType>();

    final ValueNotifier<bool> invalidCode = useState(false);

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AuthHeader(
            title: context.i18n.enter_code_title,
            icon: Assets.images.misc.authEnterCode.icon(
              size: 74.0.s,
            ),
            iconOffset: 12.0.s,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                context.i18n.enter_code_description,
                style: context.theme.appTextThemes.subtitle2.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0.s),
                child: Text(
                  phoneNumber,
                  style: context.theme.appTextThemes.subtitle.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0.s),
                child: SizedBox(
                  height: 95.0.s,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CodeFields(
                        controller: codeController,
                        errorAnimationController: errorController,
                        invalidCode: invalidCode.value,
                        onCompleted: (String completed) async {
                          if (completed != code) {
                            invalidCode.value = true;
                            codeController.clear();
                            errorController.add(ErrorAnimationType.shake);
                          } else {
                            hideKeyboardAndCall(
                              context,
                              callback: () {
                                IceRoutes.fillProfile.pushReplacement(context);
                              },
                            );
                          }
                        },
                        onChanged: (String text) {
                          if (invalidCode.value) {
                            invalidCode.value = false;
                          }
                        },
                      ),
                      if (invalidCode.value)
                        Text(
                          context.i18n.enter_code_invalid_code,
                          style: context.theme.appTextThemes.body.copyWith(
                            color: context.theme.appColors.attentionRed,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                context.i18n.enter_code_available_in,
                style: context.theme.appTextThemes.subtitle2.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
              ),
              Text(
                ' 3.0.s', // TODO: Add countdown timer
                style: context.theme.appTextThemes.subtitle2
                    .copyWith(color: context.theme.appColors.primaryAccent),
              ),
            ],
          ),
          Assets.images.logo.logoIce.icon(size: 65.0.s),
          Padding(
            padding: EdgeInsets.only(
              bottom: 14.0.s + MediaQuery.paddingOf(context).bottom,
            ),
            child: const TermsPrivacy(),
          ),
        ],
      ),
    );
  }
}
