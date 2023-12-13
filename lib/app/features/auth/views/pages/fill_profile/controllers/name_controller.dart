import 'package:flutter/cupertino.dart';

class NameController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  String errorMessage = '';

  void onVerify() {
    final String trimmedNickname = nameController.text.trim();

    if (trimmedNickname.length <= 5) {
      errorMessage = 'Text is too short, should be more than 5 characters';
    }
  }

  void dispose() {
    nameController.dispose();
  }
}
