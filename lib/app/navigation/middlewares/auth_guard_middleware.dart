import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/auth/controllers/auth_controller.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/navigation/app_pages.dart';

class AuthGuardMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();
    return authController.state is Authenticated || route == Routes.auth
        ? null
        : const RouteSettings(name: Routes.auth);
  }
}
