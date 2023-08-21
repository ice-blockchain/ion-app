import 'package:get/get.dart';
import 'package:ice/app/features/auth/controllers/auth_controller.dart';

class AppGlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}
