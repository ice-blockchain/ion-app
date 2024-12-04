// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/copy/copy_builder.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.dart';
import 'package:ion/app/features/protect_account/common/two_fa_utils.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class CopyKeyCard extends HookConsumerWidget {
  const CopyKeyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final textTheme = context.theme.appTextThemes;

    final code = useState<String?>(null);

    useOnInit(() async {
      code.value = await requestTwoFACode(ref, const TwoFAType.authenticator());
    });

    return RoundedCard.filled(
      padding: EdgeInsets.symmetric(vertical: 40.0.s),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.iconFieldIdentitykey.icon(
                size: 16.0.s,
                color: context.theme.appColors.onTertararyBackground,
              ),
              SizedBox(width: 6.0.s),
              Text(
                locale.authenticator_setup_key,
                style: textTheme.caption2.copyWith(
                  color: context.theme.appColors.onTertararyBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0.s),
          code.value?.map(
                (value) => Text(
                  value,
                  style: textTheme.subtitle,
                ),
              ) ??
              IONLoadingIndicator(
                type: ref.watch(appThemeModeProvider) == ThemeMode.dark
                    ? IndicatorType.light
                    : IndicatorType.dark,
              ),
          SizedBox(height: 20.0.s),
          CopyBuilder(
            builder: (context, onCopy, isCopied) => Button(
              minimumSize: Size(148.0.s, 48.0.s),
              leadingIcon: isCopied
                  ? Assets.svg.iconBlockCheckGreen.icon()
                  : Assets.svg.iconBlockCopyBlue.icon(),
              borderColor: isCopied
                  ? context.theme.appColors.success
                  : context.theme.appColors.strokeElements,
              onPressed: () {
                if (code.value == null) return;
                onCopy(code.value!);
              },
              label: Text(
                isCopied ? context.i18n.wallet_copied : context.i18n.button_copy,
                style: context.theme.appTextThemes.body.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              type: ButtonType.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
