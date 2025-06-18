// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/copy/copy_builder.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class CopyKeyCard extends ConsumerWidget {
  const CopyKeyCard({
    required this.code,
    super.key,
  });

  final String? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final textTheme = context.theme.appTextThemes;

    return RoundedCard.filled(
      padding: EdgeInsets.symmetric(vertical: 40.0.s),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconAssetColored(Assets.svgIconFieldIdentitykey,
                size: 16,
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
          Padding(
            padding: EdgeInsetsDirectional.only(top: 10.0.s, bottom: 20.0.s),
            child: _Code(code: code),
          ),
          if (code != null)
            CopyBuilder(
              defaultIcon: const IconAsset(Assets.svgIconBlockCopyBlue),
              defaultText: context.i18n.button_copy,
              defaultBorderColor: context.theme.appColors.strokeElements,
              builder: (context, onCopy, content) => Button(
                minimumSize: Size(148.0.s, 48.0.s),
                leadingIcon: content.icon,
                borderColor: content.borderColor,
                onPressed: () => onCopy(code!),
                label: Text(
                  content.text,
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

class _Code extends ConsumerWidget {
  const _Code({required this.code});

  final String? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.theme.appTextThemes;
    if (code case final code?) {
      return Text(
        code,
        style: textTheme.subtitle,
      );
    }
    return IONLoadingIndicator(
      type: ref.watch(appThemeModeProvider) == ThemeMode.dark
          ? IndicatorType.light
          : IndicatorType.dark,
    );
  }
}
