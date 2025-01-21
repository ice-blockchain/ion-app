// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';

class ChannelNameTile extends ConsumerWidget {
  const ChannelNameTile({
    required this.name,
    super.key,
  });

  double get verifiedIconSize => 16.0.s;

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            textAlign: TextAlign.center,
            name,
            style: context.theme.appTextThemes.title.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
