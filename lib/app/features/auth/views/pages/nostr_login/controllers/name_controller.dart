import 'package:flutter/cupertino.dart';

class PrivateKeyController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String errorMessage = '';

  String? onVerify() {
    final String trimmed = controller.text.trim();

    if (trimmed.length != 64) {
      errorMessage = 'Private key must be 64 characters long';
    }

    final RegExp validFormat = RegExp(r'^nsec[0-9a-fA-F]+$');
    if (!validFormat.hasMatch(trimmed)) {
      errorMessage = 'Invalid private key format';
    }

    return errorMessage.isEmpty ? null : errorMessage;
  }

  void dispose() {
    controller.dispose();
  }
}
