// SPDX-License-Identifier: ice License 1.0

abstract class IonException implements Exception {
  const IonException([this.message]);

  final String? message;
}

class UnauthenticatedException extends IonException {
  const UnauthenticatedException() : super('User is not authenticated');
}

class UserDeactivatedException extends IonException {
  const UserDeactivatedException() : super('User account has been deactivated');
}

class UserNotFoundException extends IonException {
  const UserNotFoundException() : super('User not found');
}

class PasskeyNotAvailableException extends IonException {
  const PasskeyNotAvailableException() : super('Passkey not available');
}

class PasskeyValidationException extends IonException {
  const PasskeyValidationException() : super('Passkey validation failed');
}

class UnknownIonException extends IonException {
  const UnknownIonException([super.message]);
}
