import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/core/controllers/init_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final InitController initController = Get.put(InitController());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("I'm Splash")),
    );
  }
}
