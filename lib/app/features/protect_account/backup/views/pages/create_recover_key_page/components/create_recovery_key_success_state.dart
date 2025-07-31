// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/backup/views/components/errors/screenshot_security_alert.dart';
import 'package:ion/app/features/protect_account/backup/views/components/recovery_key_option.dart';
import 'package:ion/app/features/protect_account/backup/views/pages/create_recover_key_page/hooks/use_screenshot_detector.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/hooks/use_route_presence.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class CreateRecoveryKeySuccessState extends HookWidget {
  const CreateRecoveryKeySuccessState({required this.recoveryData, super.key});

  final RecoveryCredentials recoveryData;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final disabledOptions = useState(<int>{});

    useEffect(
      () {
        if (disabledOptions.value.isEmpty) {
          return null;
        }

        final timer = Timer(
          const Duration(seconds: 2),
          () => disabledOptions.value = {},
        );

        return timer.cancel;
      },
      [disabledOptions.value],
    );

    final showScreenshotSecurityAlert = useCallback(
      () => showSimpleBottomSheet<void>(
        context: context,
        child: const ScreenshotSecurityAlert(),
      ),
    );

    final screenshotDetector = useScreenshotDetector();
    useOnInit(() => screenshotDetector.startListening((_) => showScreenshotSecurityAlert()));
    useRoutePresence(
      onBecameActive: () => screenshotDetector.startListening((_) => showScreenshotSecurityAlert()),
      onBecameInactive: screenshotDetector.stopListening,
    );

    return ScreenSideOffset.large(
      child: Column(
        children: [
          RecoveryKeyOption(
            title: locale.common_identity_key_name,
            iconAsset: Assets.svg.iconIdentitykey,
            subtitle: recoveryData.identityKeyName,
            onTap: () => _onOptionTap(0, disabledOptions),
            enabled: !disabledOptions.value.contains(0),
          ),
          SizedBox(height: 12.0.s),
          RecoveryKeyOption(
            title: locale.restore_identity_creds_recovery_key,
            iconAsset: Assets.svg.iconChannelPrivate,
            subtitle: recoveryData.recoveryKeyId,
            onTap: () => _onOptionTap(1, disabledOptions),
            enabled: !disabledOptions.value.contains(1),
          ),
          SizedBox(height: 12.0.s),
          RecoveryKeyOption(
            title: locale.restore_identity_creds_recovery_code,
            iconAsset: Assets.svg.iconCode4,
            subtitle: recoveryData.recoveryCode,
            onTap: () => _onOptionTap(2, disabledOptions),
            enabled: !disabledOptions.value.contains(2),
          ),
          SizedBox(height: 20.0.s),
          const _StoringKeysWarning(),
          SizedBox(height: 20.0.s),
          ScreenBottomOffset(
            margin: 36.0.s,
            child: Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(locale.button_continue),
              onPressed: () => ValidateRecoveryKeyRoute().push<void>(context),
            ),
          ),
        ],
      ),
    );
  }

  void _onOptionTap(
    int index,
    ValueNotifier<Set<int>> disabledOptions,
  ) {
    disabledOptions.value = {0, 1, 2}.difference({index});
  }
}

class _StoringKeysWarning extends StatelessWidget {
  const _StoringKeysWarning();

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return RoundedCard.outlined(
      backgroundColor: context.theme.appColors.onTertiaryFill,
      child: ListItem(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0.s),
        backgroundColor: context.theme.appColors.secondaryBackground,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0.s),
        ),
        leading: Assets.svg.iconReport.icon(
          size: 20.0.s,
          color: context.theme.appColors.attentionRed,
        ),
        title: Text(
          locale.warning_avoid_storing_keys,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.attentionRed,
          ),
          maxLines: 3,
        ),
      ),
    );
  }
}
