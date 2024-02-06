import 'package:flutter/cupertino.dart';

class PhoneNumberController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String errorMessage = '';

  String? onVerify() {
    //TODO: validate phone number locally here
    return null;
  }

  void dispose() {
    controller.dispose();
  }
}
