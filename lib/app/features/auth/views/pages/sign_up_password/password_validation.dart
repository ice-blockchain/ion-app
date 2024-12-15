// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/password_validation_error_type.dart';
import 'package:ion/app/features/auth/views/pages/sign_up_password/password_validation_row.dart';

class PasswordValidation extends HookWidget {
  const PasswordValidation({
    required this.password,
    required this.showValidation,
    super.key,
  });

  final String? password;
  final bool showValidation;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: showValidation
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0.s,
              ),
              child: Column(
                children: [
                  for (final errorType in PasswordValidationErrorType.values) ...[
                    PasswordValidationRow(
                      password: password,
                      passwordValidationErrorType: errorType,
                    ),
                    SizedBox(
                      height: 6.0.s,
                    ),
                  ],
                ],
              ),
            )
          : const SizedBox(width: double.maxFinite),
    );
  }
}
