import 'package:flutter/cupertino.dart';

class NameController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String errorMessage = '';

  void onVerify() {
    final String trimmedName = controller.text.trim();

    if (trimmedName.length <= 5) {
      errorMessage = 'Text is too short, should be more than 5 characters';
    }
  }

  void dispose() {
    controller.dispose();
  }
}
