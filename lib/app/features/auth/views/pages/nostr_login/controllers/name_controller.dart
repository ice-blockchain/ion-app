import 'package:flutter/cupertino.dart';

class PrivateKeyController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String errorMessage = '';

  String? onVerify() {
    final String trimmed = controller.text.trim();

    if (trimmed.length <= 10) {
      errorMessage =
          'Private key is too short, should be more than 10 characters';
    }

    return errorMessage.isEmpty ? null : errorMessage;
  }

  void dispose() {
    controller.dispose();
  }
}
