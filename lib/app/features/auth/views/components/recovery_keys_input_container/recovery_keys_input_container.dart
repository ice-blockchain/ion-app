import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/features/protect_account/backup/views/components/recovery_key_input.dart';
import 'package:ice/app/features/protect_account/backup/data/models/recovery_keys.dart';
import 'package:ice/app/features/protect_account/secure_account/providers/security_account_provider.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeysInputContainer extends HookConsumerWidget {
  const RecoveryKeysInputContainer({
    required this.onContinuePressed,
    super.key,
  });

  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final controllers = {
      for (final key in RecoveryKeys.values) key: useTextEditingController(),
    };

    return SheetContent(
      body: AuthScrollContainer(
        title: context.i18n.backup_option_with_recovery_keys_title,
        description: context.i18n.restore_identity_creds_description,
        icon: Assets.svg.iconLoginRestorekey.icon(size: 36.0.s),
        titleStyle: context.theme.appTextThemes.headline2,
        descriptionStyle: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.secondaryText,
        ),
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
                            prefixIcon:
                                key.iconAsset.icon(color: context.theme.appColors.secondaryText),
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
                    ref.read(securityAccountControllerProvider.notifier).toggleBackup(true);
                    onContinuePressed();
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
