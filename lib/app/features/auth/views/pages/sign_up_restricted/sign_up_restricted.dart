// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SignUpRestrictedPage extends StatelessWidget {
  const SignUpRestrictedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: KeyboardDismissOnTap(
        child: AuthScrollContainer(
          title: context.i18n.registration_restricted_title,
          description: context.i18n.registration_restricted_desc,
          icon: Assets.svg.iconClockCircle.icon(size: 36.0.s),
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
