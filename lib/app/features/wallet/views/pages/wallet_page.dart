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
            const SizedBox(width: 30),
            ElevatedButton.icon(
              label: const Text('Show Snack Bar'),
              icon: const Icon(Icons.alarm),
              onPressed: () => <void>{
                Get.snackbar(
                  "Hey i'm a Get SnackBar!", // title
                  "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
                  icon: const Icon(Icons.alarm),
                  shouldIconPulse: true,
                  barBlur: 10,
                  isDismissible: true,
                )
              },
            ),
            const SizedBox(width: 30),
            ElevatedButton.icon(
              label: const Text('Show Dialog'),
              icon: const Icon(Icons.alarm_add),
              onPressed: () => <void>{
                Get.defaultDialog(
                  onConfirm: () => <void>{Get.back()},
                  middleText:
                      'Dialog made in 3 lines of code. Dialog made in 3 lines of code',
                )
              },
            ),
            const SizedBox(width: 30),
            ElevatedButton.icon(
              label: const Text('Show Bottom Sheet'),
              icon: const Icon(Icons.arrow_upward),
              onPressed: () => <void>{
                Get.bottomSheet(Center(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.music_note),
                        title: const Text('Music'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.videocam),
                        title: const Text('Video'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ))
              },
            ),
          ],
        ),
      ),
    );
  }
}
