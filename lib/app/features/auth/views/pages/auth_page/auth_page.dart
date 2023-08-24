import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/auth/controllers/auth_controller.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/generated/app_localizations.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.of(context)!.hello('Kir'))),
      body: Column(
        children: <Widget>[
          Center(
            child: ElevatedButton.icon(
              icon: Obx(
                () => authController.state is AuthenticationLoading
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Icon(Icons.login),
              ),
              label: const Text('sign in'),
              onPressed: () => <void>{
                authController.signIn(email: 'foo@bar.baz', password: '123'),
              },
            ),
          ),
          Image.asset(Assets.images.foo.path),
        ],
      ),
    );
  }
}
