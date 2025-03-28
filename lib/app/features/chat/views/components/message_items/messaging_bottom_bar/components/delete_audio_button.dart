// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteAudioButton extends ConsumerWidget {
  const DeleteAudioButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0.s, 4.0.s, 4.0.s, 4.0.s),
        child: Assets.svg.iconBlockDelete.icon(
          color: context.theme.appColors.primaryText,
          size: 24.0.s,
        ),
      ),
    );
  }
}
