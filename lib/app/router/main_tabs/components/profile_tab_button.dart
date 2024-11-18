// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

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
    final userPicture =
        ref.watch(currentUserMetadataProvider.select((value) => value.valueOrNull?.data.picture));

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
          child: Avatar(
            size: avatarSize,
            fit: BoxFit.cover,
            imageUrl: userPicture,
            borderRadius: BorderRadius.circular(4.0.s),
          ),
        ),
      ],
    );
  }
}
