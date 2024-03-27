import 'package:email_validator/email_validator.dart';

class Validators {
  Validators._();

  static bool notEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static bool validEmail(String? value) {
    return Validators.notEmpty(value) && EmailValidator.validate(value!);
  }

  static bool validLength(String? value, {int? minLength, int? maxLength}) {
    assert(minLength != null || maxLength != null);

    if (value == null) return false;
    if (minLength != null && value.length < minLength) return false;
    if (maxLength != null && value.length > maxLength) return false;

    return true;
  }
}
