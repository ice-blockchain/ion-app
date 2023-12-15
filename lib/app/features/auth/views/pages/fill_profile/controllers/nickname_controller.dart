import 'package:flutter/cupertino.dart';

class NicknameController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String errorMessage = '';

  void onVerify() {
    final String trimmedNickname = controller.text.trim();

    if (trimmedNickname.length <= 5) {
      errorMessage = 'Text is too short, should be more than 5 characters';
    }
  }

  void dispose() {
    controller.dispose();
  }
}
