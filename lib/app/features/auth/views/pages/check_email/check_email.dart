import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
import 'package:ice/app/shared/widgets/terms_privacy/terms_privacy.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CheckEmail extends IceSimplePage {
  const CheckEmail(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final StreamController<ErrorAnimationType> errorController =
        StreamController<ErrorAnimationType>();
    const String email = 'hello@ice.io';
    final TextEditingController textEditingController =
        TextEditingController(text: '1234');

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 65,
                ),
                Image.asset(
                  Assets.images.iceRound.path,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Check email',
                  style: context.theme.appTextThemes.headline1,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('We emailed a magic link to'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      email,
                      style: context.theme.appTextThemes.subtitle,
                    ),
                    Image.asset(Assets.images.link.path),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                  child: Text(
                    'Click the link and enter the code to log in or sign up.',
                    textAlign: TextAlign.center,
                    style: context.theme.appTextThemes.subtitle2.copyWith(
                      color: context.theme.appColors.secondaryText,
                    ),
                  ),
                ),
                SizedBox(
                  width: 248,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    animationType: AnimationType.fade,
                    enabled: false,
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
                      inactiveColor: context.theme.appColors.strokeElements,
                      disabledColor: context.theme.appColors.strokeElements,
                      activeColor: context.theme.appColors.primaryAccent,
                      errorBorderColor: context.theme.appColors.attentionRed,
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
                    controller: textEditingController,
                    onCompleted: (String completed) {},
                    onChanged: (String text) {},
                    beforeTextPaste: (String? text) {
                      //if return true => the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      return true;
                    },
                  ),
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
    );
  }
}
