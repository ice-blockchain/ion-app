// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/ion_connect_avatar/ion_connect_avatar.dart';

class ProfileTabButton extends ConsumerWidget {
  const ProfileTabButton({
    required this.isSelected,
    super.key,
  });

  static double get avatarSize => 13.0.s;

  double get borderWidth => 1.2.s;

  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          height: avatarSize + 5.0.s,
          width: avatarSize + 5.0.s,
          decoration: BoxDecoration(
            color: context.theme.appColors.tertararyBackground,
            border: Border.all(
              width: 1.2.s,
              color: isSelected
                  ? context.theme.appColors.primaryAccent
                  : context.theme.appColors.tertararyText,
            ),
            borderRadius: BorderRadius.circular(6.0.s),
          ),
          child: IonConnectAvatar(
            pubkey: currentPubkey,
            size: avatarSize,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(4.0.s),
          ),
        ),
      ],
    );
  }
}
