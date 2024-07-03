import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/hooks/use_button_animation.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends IcePage {
  const IntroPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final animation = useButtonAnimation();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Center(
            child: Assets.lottie.intro.lottie(
              fit: BoxFit.fitWidth,
              frameRate: const FrameRate(60),
              repeat: false,
            ),
          ),
          Positioned(
            left: 40.0.s,
            right: 40.0.s,
            bottom: MediaQuery.of(context).padding.bottom + 46.0.s,
            child: ScaleTransition(
              scale: animation,
              child: Button(
                onPressed: () {
                  AuthRoute().go(context);
                },
                label: Text(context.i18n.button_continue),
                leadingIcon: Assets.images.icons.iconIcelogoSecuredby
                    .icon(color: context.theme.appColors.secondaryBackground),
                trailingIcon: Assets.images.icons.iconButtonNext
                    .icon(color: context.theme.appColors.secondaryBackground),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
