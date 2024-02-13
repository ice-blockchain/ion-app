import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/shared/widgets/side_padding.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends IceSimplePage {
  const IntroPage(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, _, __) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: context.theme.appColors.secondaryBackground,
        child: Stack(
          children: <Widget>[
            // Your Lottie animation
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LottieBuilder.asset(
                  Assets.lottie.intro,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  repeat: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 85,
                    bottom: 10,
                  ),
                  child: Text(
                    'The Global Currency Reset',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                ),
                SidePadding(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '#DecentralizedFuture',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Positioned button
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.10,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed(IceRoutes.auth.name);
                  },
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
