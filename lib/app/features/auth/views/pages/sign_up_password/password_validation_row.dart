// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/password_validation_error_type.dart';
import 'package:ion/generated/assets.gen.dart';

class PasswordValidationRow extends StatelessWidget {
  const PasswordValidationRow({
    required this.password,
    required this.passwordValidationErrorType,
    super.key,
  });

  final String? password;
  final PasswordValidationErrorType passwordValidationErrorType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (passwordValidationErrorType.isInvalid(password))
          IconAsset(Assets.svgIconBlockClose3, size: 16.0)
        else
          IconAsset(Assets.svgIconBlockCheckboxOn, size: 16.0),
        SizedBox(
          width: 6.0.s,
        ),
        Expanded(
          child: Text(
            passwordValidationErrorType.getDisplayName(context),
            style: context.theme.appTextThemes.caption2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
