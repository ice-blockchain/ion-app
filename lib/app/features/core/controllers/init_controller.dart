import 'package:get/get.dart';
import 'package:ice/app/features/auth/controllers/auth_controller.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/navigation/app_pages.dart';

class InitController extends GetxController {
  @override
  void onInit() {
    _initRootBindings().then((_) => _openInitialPage());
    super.onInit();
  }

  Future<void> _initRootBindings() async {
    await Get.putAsync<AuthController>(
      () => AuthController().init(),
      permanent: true,
    );
  }

  void _openInitialPage() {
    final AuthController authController = Get.find<AuthController>();
    Get.offAllNamed(
      authController.state is Authenticated ? Routes.main : Routes.auth,
    );
  }
}
