// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ice/app/features/protect_account/components/secure_account_option.dart';
import 'package:ice/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ice/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ice/app/features/protect_account/secure_account/providers/security_account_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SecureAccountOptionsPage extends ConsumerWidget {
  const SecureAccountOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityController = ref.watch(securityAccountControllerProvider);
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(locale.protect_account_header_security),
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              ),
            ],
          ),
          SizedBox(height: 36.0.s),
          ScreenSideOffset.small(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.s),
                  child: InfoCard(
                    iconAsset: Assets.svg.actionWalletSecureaccount,
                    title: locale.protect_account_title_secure_account,
                    description: locale.protect_account_description_secure_account_2fa,
                  ),
                ),
                SizedBox(height: 32.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_backup,
                  icon: Assets.svg.iconProtectwalletIcloud.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => BackupOptionsRoute().push<void>(context),
                  isEnabled: securityController.isBackupEnabled,
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_email,
                  icon: Assets.svg.iconFieldEmail.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => EmailSetupRoute(step: EmailSetupSteps.input).push<void>(context),
                  isEnabled: securityController.isEmailEnabled,
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_authenticator,
                  icon: Assets.svg.iconLoginAuthcode.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  isEnabled: securityController.isAuthenticatorEnabled,
                  onTap: () => securityController.isAuthenticatorEnabled
                      ? AuthenticatorInitialDeleteRoute().push<void>(context)
                      : AuthenticatorSetupRoute(step: AuthenticatorSetupSteps.options)
                          .push<void>(context),
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_phone,
                  icon: Assets.svg.iconFieldPhone.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => PhoneSetupRoute(step: PhoneSetupSteps.input).push<void>(context),
                  isEnabled: securityController.isPhoneEnabled,
                ),
                ScreenBottomOffset(margin: 36.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
