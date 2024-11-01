// SPDX-License-Identifier: ice License 1.0

abstract class IONIdentityException implements Exception {
  const IONIdentityException([this.message]);

  final String? message;
}

class UnauthenticatedException extends IONIdentityException {
  const UnauthenticatedException() : super('User is not authenticated');
}

class UserDeactivatedException extends IONIdentityException {
  const UserDeactivatedException() : super('User account has been deactivated');
}

class UserNotFoundException extends IONIdentityException {
  const UserNotFoundException() : super('User not found');
}

class PasskeyNotAvailableException extends IONIdentityException {
  const PasskeyNotAvailableException() : super('Passkey not available');
}

class PasskeyValidationException extends IONIdentityException {
  const PasskeyValidationException() : super('Passkey validation failed');
}

class UnknownIONIdentityException extends IONIdentityException {
  const UnknownIONIdentityException([super.message]);
}
