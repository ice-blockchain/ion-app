import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/auth/controllers/auth_controller.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Page')),
      body: Center(
        child: ElevatedButton.icon(
          label: const Text('Sign Out'),
          icon: Obx(
            () => authController.state is AuthenticationLoading
                ? const SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Icon(Icons.logout),
          ),
          onPressed: () => <void>{authController.signOut()},
        ),
      ),
    );
  }
}
