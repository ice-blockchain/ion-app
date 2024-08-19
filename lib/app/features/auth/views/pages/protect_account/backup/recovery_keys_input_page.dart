import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/backup/components/recovery_key_input.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/backup/models/recovery_keys.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeysInputPage extends HookWidget {
  const RecoveryKeysInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useRef(GlobalKey<FormState>());
    final controllers = {
      for (var key in RecoveryKeys.values) key: useTextEditingController(),
    };

    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.backup_option_with_recovery_keys_title,
        description: context.i18n.restore_identity_creds_description,
        icon: Assets.images.icons.iconLoginRestorekey.icon(size: 36.0.s),
        children: [
          Column(
            children: [
              ScreenSideOffset.large(
                child: Form(
                  key: formKey.value,
                  child: Column(
                    children: [
                      SizedBox(height: 16.0.s),
                      ...RecoveryKeys.values.map(
                        (key) => Padding(
                          padding: EdgeInsets.only(bottom: 16.0.s),
                          child: RecoveryKeyInput(
                            controller: controllers[key]!,
                            labelText: key.getDisplayName(context),
                            prefixIcon: key.iconAsset.icon(),
                            validator: (value) {
                              if (Validators.isEmpty(value)) return '';
                              return null;
                            },
                            textInputAction: key == RecoveryKeys.recoveryCode
                                ? TextInputAction.done
                                : TextInputAction.next,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          ScreenBottomOffset(
            margin: 36.0.s,
            child: ScreenSideOffset.large(
              child: Button(
                onPressed: () {
                  if (formKey.value.currentState!.validate()) {
                    RecoveryKeysSuccessRoute().push<void>(context);
                  }
                },
                label: Text(context.i18n.button_continue),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
