import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthenticatorCodeConfirmPage extends HookWidget {
  final void Function(GlobalKey<FormState>) onFormKeySet;

  const AuthenticatorCodeConfirmPage({
    super.key,
    required this.onFormKeySet,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>());

    useEffect(() {
      onFormKeySet(formKey.value);
      return null;
    }, []);

    return Form(
      key: formKey.value,
      child: ScreenSideOffset.large(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextInput(
              controller: controller,
              labelText: context.i18n.two_fa_auth,
              prefixIcon: TextInputIcons(
                hasRightDivider: true,
                icons: [Assets.images.icons.iconRecoveryCode.icon()],
              ),
              validator: (value) => value?.isEmpty == true ? '' : null,
              textInputAction: TextInputAction.done,
              scrollPadding: EdgeInsets.only(bottom: 200.0.s),
            ),
          ],
        ),
      ),
    );
  }
}
