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

class BiometricsEnrollmentException extends IONIdentityException {
  const BiometricsEnrollmentException() : super('Biometrics enrollment failed');
}

class InvalidPasswordException extends IONIdentityException {
  const InvalidPasswordException() : super('Invalid Password');
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

  static bool isMatch(DioException dioException) {
    final responseData = dioException.response?.data;

    try {
      if (responseData is Map<String, dynamic>) {
        return responseData['error']['message'] == '2FA_REQUIRED';
      }
      return false;
    } catch (_) {
      return false;
    }
  }
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
        final responseCode = responseData['code'] as String?;
        final responseMessage = responseData['error']['message'] as String?;
        final invalidCodes = ['2FA_INVALID_CODE', '2FA_EXPIRED_CODE'];
        return invalidCodes.contains(responseCode) || invalidCodes.contains(responseMessage);
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

class TwoFaMethodNotConfiguredException extends IONIdentityException {
  TwoFaMethodNotConfiguredException() : super('2FA option not configured for the account');

  static bool isMatch(DioException dioException) {
    final responseData = dioException.response?.data;

    try {
      if (responseData is Map<String, dynamic>) {
        return responseData['code'] == '2FA_NOT_CONFIGURED';
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

class InvalidRecoveryCredentialsException extends IONIdentityException {
  InvalidRecoveryCredentialsException() : super('Invalid recovery credentials');

  static bool isMatch(DioException dioException) {
    final responseData = dioException.response?.data;

    try {
      if (responseData is Map<String, dynamic>) {
        final errorMessage = responseData['error']['message'] as String?;
        final recoveryKeyNotFound = errorMessage == 'Recovery key not found.';
        final userNotFound = errorMessage == 'USER_NOT_FOUND';
        return recoveryKeyNotFound || userNotFound;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

class InvalidSignatureException extends IONIdentityException {
  InvalidSignatureException() : super('Invalid signature');

  static bool isMatch(DioException dioException) {
    final responseData = dioException.response?.data;

    try {
      if (responseData is Map<String, dynamic>) {
        final responseCode = responseData['code'] as String?;
        return responseCode == 'INVALID_SIGNATURE';
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
