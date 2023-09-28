import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
                'assets/lottie/splash-logo.json',
                width: double.infinity,
                fit: BoxFit.fitWidth,
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
                    // Navigate to the Auth route
                    GoRouter.of(context).go('/auth');
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
