// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion_identity_client/ion_identity.dart';

extension RequestExecutionExceptionExtention on RequestExecutionException {
  static const _userAlreadyExistsErrorMessage = 'user already exists';

  String localizedString(BuildContext context) {
    final error = this.error;

    if (error is DioException && error.response?.statusCode == 401) {
      final responseData = error.response?.data;

      if (responseData is String) {
        final jsonError = jsonDecode(responseData) as Map<String, dynamic>;
        final error = jsonError['error'] as Map<String, dynamic>;
        final message = error['message']?.toString().toLowerCase() ?? '';

        if (message.contains(_userAlreadyExistsErrorMessage)) {
          return context.i18n.sign_up_passkey_identity_key_name_taken;
        }
      }
    }

    return toString();
  }
}
