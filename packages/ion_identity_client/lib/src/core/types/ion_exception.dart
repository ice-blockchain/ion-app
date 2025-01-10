// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';

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

class BiometricsValidationException extends IONIdentityException {
  const BiometricsValidationException() : super('Biometrics validation failed');
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

class UserAlreadyExistsException extends IONIdentityException {
  const UserAlreadyExistsException() : super('User already exists');

  static bool isMatch(DioException dioException) {
    final responseData = dioException.response?.data;

    if (responseData == null) return false;
    if (responseData is! String) return false;

    try {
      final jsonError = jsonDecode(responseData) as Map<String, dynamic>;
      final error = jsonError['error'] as Map<String, dynamic>?;
      if (error == null) return false;

      final errorMessage = const UserAlreadyExistsException().message?.toLowerCase();
      if (errorMessage == null) return false;

      final message = error['message']?.toString().toLowerCase();
      if (message == null) return false;

      return message.contains(errorMessage);
    } catch (_) {
      return false;
    }
  }
}

class InvalidTwoFaCodeException extends IONIdentityException {
  InvalidTwoFaCodeException() : super('Invalid 2FA code');

  static bool isMatch(DioException dioException) {
    final responseData = dioException.response?.data;

    try {
      if (responseData is Map<String, dynamic>) {
        return responseData['code'] == '2FA_INVALID_CODE';
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
