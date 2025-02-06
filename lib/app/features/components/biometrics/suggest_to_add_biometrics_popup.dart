// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/biometrics_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class SuggestToAddBiometricsPopup extends ConsumerWidget {
  const SuggestToAddBiometricsPopup({
    required this.username,
    required this.password,
    super.key,
  });

  final String username;
  final String password;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minSize = Size(56.0.s, 56.0.s);
    final biometricsActionsState = ref.watch(biometricsActionsNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0.s, right: 30.0.s, top: 30.0.s),
          child: InfoCard(
            iconAsset: Assets.svg.actionWalletFaceid,
            title: context.i18n.biometrics_suggestion_title,
            description: context.i18n.biometrics_suggestion_desc,
          ),
        ),
        SizedBox(height: 38.0.s),
        ScreenSideOffset.small(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Button.compact(
                  type: ButtonType.outlined,
                  label: Text(context.i18n.button_cancel),
                  minimumSize: minSize,
                  onPressed: () {
                    ref
                        .read(biometricsActionsNotifierProvider.notifier)
                        .rejectToUseBiometrics(username: username);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                width: 16.0.s,
              ),
              Expanded(
                child: Button.compact(
                  label: Text(context.i18n.button_continue),
                  minimumSize: minSize,
                  disabled: biometricsActionsState.isLoading,
                  trailingIcon: biometricsActionsState.isLoading
                      ? const IONLoadingIndicator()
                      : const SizedBox.shrink(),
                  onPressed: () async {
                    await ref
                        .read(biometricsActionsNotifierProvider.notifier)
                        .enrollToUseBiometrics(
                          username: username,
                          password: password,
                          localisedReason: context.i18n.biometrics_suggestion_title,
                        );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
