import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/features/auth/controllers/auth_controller.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/theme/colors.dart';
import 'package:ice/app/theme/text_styles.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Page'),
      ),
      body: Container(
        decoration: BoxDecoration(color: context.theme.appColors.background),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
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
              Text(
                'Styled Text',
                style: AppTypography.body1.copyWith(
                  color: context.theme.appColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
