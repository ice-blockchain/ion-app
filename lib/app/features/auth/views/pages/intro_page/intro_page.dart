import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/shared/widgets/modal_wrapper.dart';
import 'package:ice/app/shared/widgets/side_padding.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends HookConsumerWidget {
  const IntroPage({super.key});

  void showMyBottomSheet(BuildContext context) {
    // const AuthRoute().go(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const ModalWrapper(
        child: AuthPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  'assets/lottie/intro.json',
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
                    showMyBottomSheet(context);
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
