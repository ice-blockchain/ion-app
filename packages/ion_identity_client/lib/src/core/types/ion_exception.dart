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

class PasswordFlowNotAvailableForTheUserException extends IONIdentityException {
  const PasswordFlowNotAvailableForTheUserException()
      : super('Password flow is not available for this user');
}

class TwoFARequiredException extends IONIdentityException {
  const TwoFARequiredException(
    this.twoFAOptionsCount,
  ) : super('Two-factor authentication is required');

  final int twoFAOptionsCount;
}

class UnknownIONIdentityException extends IONIdentityException {
  const UnknownIONIdentityException([super.message]);
}

class IncompleteDataIONIdentityException extends IONIdentityException {
  const IncompleteDataIONIdentityException([super.message]);
}
