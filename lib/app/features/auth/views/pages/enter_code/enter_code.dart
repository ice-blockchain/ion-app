import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/shared/widgets/terms_privacy/terms_privacy.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCode extends HookConsumerWidget {
  const EnterCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  const SizedBox(
                    height: 65,
                  ),
                  Image.asset(
                    Assets.images.enterCode.path,
                  ),
                  const SizedBox(
                    height: 9,
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
                    padding: const EdgeInsets.only(top: 30, bottom: 19),
                    child: SizedBox(
                      width: 248,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        animationType: AnimationType.fade,
                        cursorColor: Colors.black,
                        cursorWidth: 3,
                        cursorHeight: 25,
                        textStyle: context.theme.appTextThemes.inputFieldText,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(16),
                          fieldHeight: 56,
                          fieldWidth: 50,
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
                    ' 30s', // TODO: Add countdown timer
                    style: context.theme.appTextThemes.subtitle2
                        .copyWith(color: context.theme.appColors.primaryAccent),
                  ),
                ],
              ),
              Image.asset(
                Assets.images.iceRound.path,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: TermsPrivacy(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
