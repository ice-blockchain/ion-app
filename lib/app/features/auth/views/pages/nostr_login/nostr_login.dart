import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/auth_header/auth_header.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_fields.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/auth/views/pages/nostr_login/controllers/name_controller.dart';
import 'package:ice/generated/assets.gen.dart';

class NostrLogin extends HookConsumerWidget {
  const NostrLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PrivateKeyController privateKeyController = PrivateKeyController();
    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenSideOffset.large(
          child: Column(
            children: <Widget>[
              AuthHeaderWidget(
                title: context.i18n.nostr_login_title,
                description: context.i18n.nostr_login_description,
              ),
              const SizedBox(
                height: 15,
              ),
              Image.asset(
                Assets.images.ostrichlogo.path,
                width: 256,
                height: 160,
              ),
              const SizedBox(
                height: 80,
              ),
              Column(
                children: <Widget>[
                  InputField(
                    leadingIcon: ImageIcon(
                      AssetImage(Assets.images.fieldPrivatekey.path),
                    ),
                    label: context.i18n.nostr_login_input_private_key,
                    controller: privateKeyController.controller,
                    validator: (String? value) =>
                        privateKeyController.onVerify(),
                    showLeadingSeparator: true,
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Center(
                    child: Button(
                      leadingIcon: ImageIcon(
                        AssetImage(Assets.images.profilePaste.path),
                        size: 24,
                      ),
                      onPressed: () {},
                      type: ButtonType.disabled,
                      label: Text(context.i18n.button_paste),
                      mainAxisSize: MainAxisSize.max,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
