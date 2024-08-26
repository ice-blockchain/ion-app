import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/delete_authenticator/components/two_fa_input_list.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/providers/protect_account_provider.dart';
import 'package:ice/app/features/auth/views/pages/twofa_try_again/twofa_try_again_page.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';

class AuthenticatorDeleteInputPage extends HookConsumerWidget {
  const AuthenticatorDeleteInputPage({
    super.key,
    required this.twoFaTypes,
  });

  final Set<TwoFaType> twoFaTypes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useRef(GlobalKey<FormState>());

    return ScreenSideOffset.large(
      child: Form(
        key: formKey.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TwoFaCodeInputList(twoFaTypes: twoFaTypes.toList()),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_confirm),
              onPressed: () {
                if (formKey.value.currentState!.validate()) {
                  hideKeyboardAndCallOnce(callback: () => _onConfirm(ref, context));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _onConfirm(WidgetRef ref, BuildContext context) {
    if (Random().nextBool() == true) {
      ref.read(securityContorllerProvider.notifier).toggleAuthenticator(false);
      AuthenticatorDeleteSuccessRoute().push<void>(context);
    } else {
      showSimpleBottomSheet<void>(
        context: context,
        child: const TwoFaTryAgainPage(),
      );
    }
  }
}
