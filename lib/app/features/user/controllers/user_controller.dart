import 'package:get/get.dart';
import 'package:ice/app/features/auth/controllers/auth_controller.dart';

class UserController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    // authController.authStateStream.listen((authState) {
    //   print('ooopaaa! ${authState}');
    // });
    super.onInit();
  }
}
