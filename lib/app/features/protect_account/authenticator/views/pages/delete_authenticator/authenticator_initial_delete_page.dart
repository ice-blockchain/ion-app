import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthenticatorInitialDeletePage extends StatelessWidget {
  const AuthenticatorInitialDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(locale.two_fa_option_authenticator),
          ),
          AuthHeader(
            topOffset: 34.0.s,
            title: locale.two_fa_option_authenticator,
            titleStyle: context.theme.appTextThemes.headline2,
            descriptionStyle: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.secondaryText,
            ),
            icon: AuthHeaderIcon(
              icon: Assets.svg.icon2faAuthsetup.icon(size: 36.0.s),
            ),
          ),
          SizedBox(height: 42.0.s),
          ScreenSideOffset.large(
            child: RoundedCard.filled(
              padding: EdgeInsets.symmetric(
                vertical: 80.0.s,
                horizontal: 12.0.s,
              ),
              child: Column(
                children: [
                  Assets.svg.actionWalletGoogleauth.icon(size: 80.0.s),
                  SizedBox(height: 20.0.s),
                  Text(
                    locale.authenticator_is_linked_to_account,
                    textAlign: TextAlign.center,
                    style: context.theme.appTextThemes.caption2.copyWith(
                      color: context.theme.appColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ScreenSideOffset.large(
            child: Button(
              type: ButtonType.outlined,
              mainAxisSize: MainAxisSize.max,
              label: Text(locale.button_delete),
              onPressed: () => AuthenticatorDeleteRoute(
                step: AuthenticatorDeleteSteps.select,
              ).push<void>(context),
            ),
          ),
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }
}
