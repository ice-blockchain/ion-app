// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/pages/get_started/login_form.dart';
import 'package:ion/app/features/user/providers/user_verify_identity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class GetStartedStep extends ConsumerWidget {
  const GetStartedStep({
    required this.onLogin,
    super.key,
  });

  final void Function(String username) onLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasskeyAvailable = ref.watch(isPasskeyAvailableProvider).valueOrNull ?? false;
    return SheetContent(
      body: KeyboardDismissOnTap(
        child: AuthScrollContainer(
          showBackButton: false,
          title: context.i18n.get_started_title,
          description: context.i18n.get_started_description,
          icon: Assets.svg.iconLoginIcelogo.icon(size: 44.0.s),
          children: [
            ScreenSideOffset.large(
              child: Column(
                children: [
                  SizedBox(height: 56.0.s),
                  LoginForm(
                    onLogin: onLogin,
                  ),
                  SizedBox(height: 14.0.s),
                  Text(
                    context.i18n.get_started_method_divider,
                    style: context.theme.appTextThemes.caption.copyWith(
                      color: context.theme.appColors.tertararyText,
                    ),
                  ),
                  SizedBox(height: 14.0.s),
                  Button(
                    type: ButtonType.outlined,
                    leadingIcon: Assets.svg.iconLoginCreateacc.icon(
                      color: context.theme.appColors.secondaryText,
                    ),
                    onPressed: () {
                      if (isPasskeyAvailable) {
                        SignUpPasskeyRoute().push<void>(context);
                      } else {
                        SignUpPasswordRoute().push<void>(context);
                      }
                    },
                    label: Text(context.i18n.button_register),
                    mainAxisSize: MainAxisSize.max,
                  ),
                  SizedBox(height: 16.0.s),
                  Button(
                    type: ButtonType.outlined,
                    leadingIcon: Assets.svg.iconRestorekey.icon(
                      color: context.theme.appColors.secondaryText,
                    ),
                    onPressed: () {
                      RestoreMenuRoute().push<void>(context);
                    },
                    label: Text(context.i18n.get_started_restore_button),
                    mainAxisSize: MainAxisSize.max,
                    borderColor: Colors.transparent,
                  ),
                  SizedBox(height: 16.0.s),
                  ScreenBottomOffset(child: const AuthFooter()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
