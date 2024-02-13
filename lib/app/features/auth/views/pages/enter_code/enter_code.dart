import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/terms_privacy/terms_privacy.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCode extends IceSimplePage {
  const EnterCode(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    const String phoneNumber = '+101234567890';
    final TextEditingController codeController = TextEditingController();

    final StreamController<ErrorAnimationType> errorController =
        StreamController<ErrorAnimationType>();

    final ValueNotifier<bool> invalidCode = useState(false);

    return Scaffold(
      body: ScreenSideOffset.large(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 65.0.s,
                  ),
                  Image.asset(
                    Assets.images.enterCode.path,
                  ),
                  SizedBox(
                    height: 9.0.s,
                  ),
                  Text(
                    context.i18n.enter_code_title,
                    style: context.theme.appTextThemes.headline1,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(context.i18n.enter_code_description),
                  Text(
                    phoneNumber,
                    style: context.theme.appTextThemes.subtitle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0.s, bottom: 19.0.s),
                    child: SizedBox(
                      width: 248.0.s,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        animationType: AnimationType.fade,
                        cursorColor: Colors.black,
                        cursorWidth: 3.0.s,
                        cursorHeight: 25.0.s,
                        textStyle: context.theme.appTextThemes.inputFieldText,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(16.0.s),
                          fieldHeight: 56.0.s,
                          fieldWidth: 50.0.s,
                          borderWidth: 1,
                          inactiveColor: invalidCode.value
                              ? context.theme.appColors.attentionRed
                              : context.theme.appColors.strokeElements,
                          disabledColor: context.theme.appColors.strokeElements,
                          activeColor: invalidCode.value
                              ? context.theme.appColors.attentionRed
                              : context.theme.appColors.primaryAccent,
                          errorBorderColor:
                              context.theme.appColors.attentionRed,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          errorBorderWidth: 1,
                          activeBorderWidth: 1,
                          inactiveBorderWidth: 1,
                          disabledBorderWidth: 1,
                          selectedBorderWidth: 1,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        errorAnimationController: errorController,
                        controller: codeController,
                        onCompleted: (String completed) {
                          if (completed != '1111') {
                            invalidCode.value = true;
                            errorController.add(
                              ErrorAnimationType.shake,
                            );
                          } else {
                            invalidCode.value = false;
                          }
                        },
                        onChanged: (String text) {
                          if (invalidCode.value) {
                            invalidCode.value = false;
                          }
                        },
                        beforeTextPaste: (String? text) {
                          return true;
                        },
                      ),
                    ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    context.i18n.enter_code_available_in,
                    style: context.theme.appTextThemes.subtitle2,
                  ),
                  Text(
                    ' 3.0.s', // TODO: Add countdown timer
                    style: context.theme.appTextThemes.subtitle2
                        .copyWith(color: context.theme.appColors.primaryAccent),
                  ),
                ],
              ),
              Image.asset(
                Assets.images.iceRound.path,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 48.0.s),
                child: const TermsPrivacy(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
