import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class IdentityInfo extends StatelessWidget {
  const IdentityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: context.i18n.wallet_receive,
          actions: const [NavigationCloseButton()],
        ),
        const AuthFooter(),
        ScreenBottomOffset(),
      ],
    );
  }
}
