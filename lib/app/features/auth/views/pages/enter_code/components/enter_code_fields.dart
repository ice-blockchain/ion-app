import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/code_fields/code_fields.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCodeFields extends HookWidget {
  const EnterCodeFields({super.key});

  @override
  Widget build(BuildContext context) {
    const code = '1111';

    final codeController = useTextEditingController();
    final errorController = useStreamController<ErrorAnimationType>();
    final invalidCode = useState(false);
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return SizedBox(
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
                hideKeyboardAndCallOnce(
                  callback: () =>
                      // IceRoutes.fillProfile.pushReplacement(context),
                      FillProfileRoute().pushReplacement(context),
                );
              }
            },
            onChanged: (String text) {
              if (invalidCode.value && text.isNotEmpty) {
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
    );
  }
}
