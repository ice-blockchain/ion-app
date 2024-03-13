import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_fields.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/nostr_login/controllers/name_controller.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class NostrLogin extends IceSimplePage {
  const NostrLogin(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final PrivateKeyController privateKeyController = PrivateKeyController();
    return SheetContentScaffold(
      body: SingleChildScrollView(
        child: ScreenSideOffset.large(
          child: Column(
            children: <Widget>[
              AuthHeaderWidget(
                title: context.i18n.nostr_login_title,
                description: context.i18n.nostr_login_description,
              ),
              SizedBox(
                height: 15.0.s,
              ),
              Image.asset(
                Assets.images.bg.ostrichlogo.path,
                width: 256.0.s,
                height: 160.0.s,
              ),
              SizedBox(
                height: 80.0.s,
              ),
              Column(
                children: <Widget>[
                  InputField(
                    leadingIcon: Assets.images.icons.iconFieldPrivatekey.icon(),
                    label: context.i18n.nostr_login_input_private_key,
                    controller: privateKeyController.controller,
                    validator: (String? value) =>
                        privateKeyController.onVerify(),
                    showLeadingSeparator: true,
                  ),
                  SizedBox(
                    height: 26.0.s,
                  ),
                  Center(
                    child: Button(
                      leadingIcon: Assets.images.icons.iconProfilePaste.icon(),
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
