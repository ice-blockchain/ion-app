// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/warning_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/authenticator/views/components/copy_key_card.dart';
import 'package:ion/app/features/protect_account/common/two_fa_utils.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class AuthenticatorSetupInstructionsPage extends HookConsumerWidget {
  const AuthenticatorSetupInstructionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    final code = useState<String?>(null);

    useOnInit(() async {
      code.value = await requestTwoFACode(ref, const TwoFAType.authenticator());
    });

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              actions: [
                NavigationCloseButton(
                  onPressed: Navigator.of(context, rootNavigator: true).pop,
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            pinned: true,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                AuthHeader(
                  title: context.i18n.follow_instructions_title,
                  description: context.i18n.follow_instructions_description,
                  titleStyle: context.theme.appTextThemes.headline2,
                  descriptionStyle: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                  icon: AuthHeaderIcon(
                    icon: Assets.svg.icon2faFollowinstuction.icon(size: 36.0.s),
                  ),
                ),
                SizedBox(height: 32.0.s),
                Expanded(
                  child: ScreenSideOffset.large(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        CopyKeyCard(code: code.value),
                        const Spacer(),
                        WarningCard(text: locale.warning_authenticator_setup),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 22.0.s),
                ScreenSideOffset.large(
                  child: Button(
                    mainAxisSize: MainAxisSize.max,
                    type: code.value == null ? ButtonType.disabled : ButtonType.primary,
                    label: Text(context.i18n.button_next),
                    onPressed: () => AuthenticatorSetupCodeConfirmRoute().push<void>(context),
                  ),
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
