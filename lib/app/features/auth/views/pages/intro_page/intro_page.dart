import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends HookConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blueGrey,
        child: Stack(
          children: <Widget>[
            // Your Lottie animation
            Center(
              child: LottieBuilder.asset(
                'assets/lottie/intro.json',
                width: double.infinity,
                fit: BoxFit.fitWidth,
                repeat: false,
              ),
            ),
            // Positioned button
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.10,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    const AuthRoute().go(context);
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
