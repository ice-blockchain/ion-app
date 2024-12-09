// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/passkeys/secured_by.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class PasskeyPromptDialog extends ConsumerWidget {
  const PasskeyPromptDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textThemes = context.theme.appTextThemes;
    final isThemeLight = ref.watch(appThemeModeProvider) == ThemeMode.light;

    final i18n = context.i18n;

    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.s),
        child: Column(
          children: [
            SizedBox(height: 65.0.s),
            Assets.svg.actionWalletPasskey.icon(size: 80.0.s),
            SizedBox(height: 20.0.s),
            Text(
              i18n.passkeys_prompt_title,
              textAlign: TextAlign.center,
              style: textThemes.headline1,
            ),
            SizedBox(height: 8.0.s),
            Text(
              i18n.passkeys_prompt_description,
              textAlign: TextAlign.center,
              style: textThemes.body2.copyWith(color: colors.tertararyText),
            ),
            SizedBox(height: 69.0.s),
            IONLoadingIndicator(
              size: Size.square(30.0.s),
              type: isThemeLight ? IndicatorType.dark : IndicatorType.light,
            ),
            const Spacer(),
            ScreenBottomOffset(
              child: const SecuredBy(),
            ),
          ],
        ),
      ),
    );
  }
}
