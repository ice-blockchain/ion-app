import 'dart:math';

import 'package:get/get.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/data/models/auth_token.dart';
import 'package:ice/app/navigation/app_pages.dart';

class AuthController extends GetxController {
  final Rx<AuthState> authStateStream =
      Rx<AuthState>(const AuthenticationUnknown());

  AuthState get state => authStateStream.value;

  Future<AuthController> init() async {
    await 2.seconds.delay();
    authStateStream.value = Random().nextBool()
        ? const UnAuthenticated()
        : const Authenticated(
            authToken: AuthToken(access: 'access', refresh: 'refresh'),
          );
    return this;
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      authStateStream.value = const AuthenticationLoading();
      await 2.seconds.delay();
      authStateStream.value = const Authenticated(
        authToken: AuthToken(access: 'access', refresh: 'refresh'),
      );
      Get.offAllNamed(Routes.main);
    } catch (error) {
      authStateStream.value = AuthenticationFailure(message: error.toString());
      printError(info: error.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      authStateStream.value = const AuthenticationLoading();
      await 2.seconds.delay();
      authStateStream.value = const UnAuthenticated();
      Get.offAllNamed(Routes.auth);
    } catch (error) {
      authStateStream.value = AuthenticationFailure(message: error.toString());
      printError(info: e.toString());
      rethrow;
    }
  }
}
