import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_app_bar.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/pages/get_started/login_form.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class GetStartedPage extends HookWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    return SheetContent(
      body: KeyboardDismissOnTap(
        child: SizedBox(
          height: double.infinity,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              AuthFadeInAppBar(
                showBackButton: false,
                title: context.i18n.get_started_title,
                scrollController: scrollController,
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AuthHeader(
                      title: context.i18n.get_started_title,
                      description: context.i18n.get_started_description,
                      icon: AuthHeaderIcon(
                        icon: Assets.images.icons.iconLoginIcelogo.icon(size: 36.0.s),
                      ),
                    ),
                    ScreenSideOffset.large(
                      child: Column(
                        children: [
                          SizedBox(height: 56.0.s),
                          const LoginForm(),
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
                            leadingIcon: Assets.images.icons.iconLoginCreateacc.icon(
                              color: context.theme.appColors.secondaryText,
                            ),
                            onPressed: () {
                              hideKeyboardAndCallOnce(
                                  callback: () => SignUpPasskeyRoute().push<void>(context));
                            },
                            label: Text(context.i18n.button_register),
                            mainAxisSize: MainAxisSize.max,
                          ),
                          SizedBox(height: 16.0.s),
                          Button(
                            type: ButtonType.outlined,
                            leadingIcon: Assets.images.icons.iconRestorekey.icon(
                              color: context.theme.appColors.secondaryText,
                            ),
                            onPressed: () {
                              hideKeyboardAndCallOnce(
                                  callback: () => RestoreMenuRoute().push<void>(context));
                            },
                            label: Text(context.i18n.get_started_restore_button),
                            mainAxisSize: MainAxisSize.max,
                            borderColor: Colors.transparent,
                          ),
                          SizedBox(height: 16.0.s),
                        ],
                      ),
                    ),
                    ScreenBottomOffset(child: const AuthFooter())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
