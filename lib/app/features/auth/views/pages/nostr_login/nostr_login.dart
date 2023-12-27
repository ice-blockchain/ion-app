import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/features/auth/views/pages/nostr_login/controllers/name_controller.dart';
import 'package:ice/app/shared/widgets/auth_header/auth_header.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/app/shared/widgets/inputs/text_fields.dart';
import 'package:ice/generated/assets.gen.dart';

class NostrLogin extends HookConsumerWidget {
  const NostrLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PrivateKeyController privateKeyController = PrivateKeyController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: <Widget>[
              AuthHeaderWidget(
                title: 'Nostr',
                description: 'Enter your Nostr private key',
              ),
              ImageIcon(
                AssetImage(Assets.images.loginNostr.path),
                size: 99,
              ),
              Column(
                children: <Widget>[
                  InputField(
                    leadingIcon: ImageIcon(
                      AssetImage(Assets.images.fieldPrivatekey.path),
                    ),
                    label: 'Your Private Key',
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
                      label: const Text('Paste from clipboard'),
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
