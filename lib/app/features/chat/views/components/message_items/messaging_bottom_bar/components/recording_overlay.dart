// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class RecordingOverlay extends ConsumerWidget {
  const RecordingOverlay({
    required this.paddingBottom,
    super.key,
  });

  final double paddingBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);

    return PositionedDirectional(
      bottom: MediaQuery.of(context).viewInsets.bottom + 8.0.s,
      end: 14.0.s,
      child: SafeArea(
        child: Container(
          width: 32.0.s,
          decoration: BoxDecoration(
            color: context.theme.appColors.onTerararyFill,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0.s),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (bottomBarState.isVoiceLocked)
                GestureDetector(
                  onTap: () {
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setVoicePaused();
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(top: 8.0.s),
                    child: Assets.svg.iconVideoPause.icon(
                      color: context.theme.appColors.primaryAccent,
                      size: 20.0.s,
                    ),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 4.0.s),
                  child: Container(
                    padding: EdgeInsets.all(4.0.s),
                    decoration: BoxDecoration(
                      color: paddingBottom > 20
                          ? context.theme.appColors.primaryAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0.s),
                    ),
                    child: Assets.svg.linearSecurityLockKeyholeUnlocked.icon(
                      color: paddingBottom > 20
                          ? context.theme.appColors.onPrimaryAccent
                          : context.theme.appColors.primaryAccent,
                      size: 20.0.s,
                    ),
                  ),
                ),
              SizedBox(height: 18.0.s),
              Container(
                padding: EdgeInsets.all(4.0.s),
                decoration: BoxDecoration(
                  color: context.theme.appColors.primaryAccent,
                  borderRadius: BorderRadius.circular(12.0.s),
                ),
                child: Assets.svg.iconChatMicrophone.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                  size: 24.0.s,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
