import 'package:flutter/cupertino.dart';

const String pattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class EmailController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegExp regex = RegExp(pattern);
  final TextEditingController controller = TextEditingController();

  String errorMessage = '';

  String? onVerify() {
    final String trimmedEmail = controller.text.trim();

    if (!regex.hasMatch(trimmedEmail)) {
      errorMessage = 'Enter a valid email address';
    }

    return errorMessage.isEmpty ? null : errorMessage;
  }

  void dispose() {
    controller.dispose();
  }
}
