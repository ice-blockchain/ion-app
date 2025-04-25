// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/components/about_import_token_dialog.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class SecurityRisks extends StatelessWidget {
  const SecurityRisks({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;
    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);

    if (isKeyboardVisible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(36.0.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.svg.walletIconWalletRisks.icon(size: 80.0.s),
          SizedBox(height: 6.0.s),
          Text(
            context.i18n.wallet_import_token_security_risks_title,
            style: textStyles.title.copyWith(color: colors.primaryText),
          ),
          SizedBox(height: 8.0.s),
          Text(
            context.i18n.wallet_import_token_security_risks_description,
            textAlign: TextAlign.center,
            style: textStyles.body2.copyWith(color: colors.primaryText),
          ),
          SizedBox(height: 8.0.s),
          Text.rich(
            TextSpan(
              text: context.i18n.wallet_import_token_security_risks_learn_more,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.primaryAccent,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showSimpleBottomSheet<void>(
                    context: context,
                    child: const AboutImportTokenDialog(),
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
}
