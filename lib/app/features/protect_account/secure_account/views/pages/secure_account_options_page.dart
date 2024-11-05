// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ion/app/features/protect_account/components/secure_account_option.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_steps.dart';
import 'package:ion/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/security_methods.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SecureAccountOptionsPage extends ConsumerWidget {
  const SecureAccountOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityMethods = ref.watch(securityAccountControllerProvider).valueOrNull;
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
                  isEnabled: securityMethods?.isBackupEnabled ?? false,
                  isLoading: securityMethods?.isBackupEnabled == null,
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_email,
                  icon: Assets.svg.iconFieldEmail.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => EmailSetupRoute(step: EmailSetupSteps.input).push<void>(context),
                  isEnabled: securityMethods?.isEmailEnabled ?? false,
                  isLoading: securityMethods?.isEmailEnabled == null,
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_authenticator,
                  icon: Assets.svg.iconLoginAuthcode.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  isEnabled: securityMethods?.isAuthenticatorEnabled ?? false,
                  isLoading: securityMethods?.isAuthenticatorEnabled == null,
                  onTap: () => _onAuthenticatorPressed(context, securityMethods),
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_phone,
                  icon: Assets.svg.iconFieldPhone.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => PhoneSetupRoute(step: PhoneSetupSteps.input).push<void>(context),
                  isEnabled: securityMethods?.isPhoneEnabled ?? false,
                  isLoading: securityMethods?.isPhoneEnabled == null,
                ),
                ScreenBottomOffset(margin: 36.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onAuthenticatorPressed(BuildContext context, SecurityMethods? securityMethods) {
    if (securityMethods == null) {
      return;
    }

    if (!(securityMethods.isEmailEnabled || securityMethods.isPhoneEnabled)) {
      SecureAccountErrorRoute().push<void>(context);
      return;
    }

    if (securityMethods.isAuthenticatorEnabled) {
      AuthenticatorInitialDeleteRoute().push<void>(context);
    } else {
      AuthenticatorSetupRoute(step: AuthenticatorSetupSteps.options).push<void>(context);
    }
  }
}
