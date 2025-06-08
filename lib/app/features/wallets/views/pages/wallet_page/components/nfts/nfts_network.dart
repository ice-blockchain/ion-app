// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';

class NftNetwork extends ConsumerWidget {
  const NftNetwork({
    required this.network,
    super.key,
  });

  final NetworkData network;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Avatar(
          size: 12.0.s,
          imageWidget: NetworkIconWidget(
            size: 12.0.s,
            imageUrl: network.image,
          ),
        ),
        SizedBox(width: 5.0.s),
        Text(
          network.displayName,
          style: context.theme.appTextThemes.caption3
              .copyWith(color: context.theme.appColors.quaternaryText),
        ),
      ],
    );
  }
}
