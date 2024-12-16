// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_identity.dart';

class NetworkErrors {
  static bool isUserAlreadyExistsException(DioException e) {
    final responseData = e.response?.data;

    if (responseData is String) {
      try {
        final jsonError = jsonDecode(responseData) as Map<String, dynamic>;
        final error = jsonError['error'] as Map<String, dynamic>?;

        final errorMessage = const UserAlreadyExistsException().message?.toLowerCase();
        if (error != null && errorMessage != null) {
          final message = error['message']?.toString().toLowerCase() ?? '';

          return message.toLowerCase().contains(errorMessage);
        }
      } catch (_) {
        return false;
      }
    }

    return false;
  }
}
