// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/nft_layout_type.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';

class NftNetwork extends StatelessWidget {
  const NftNetwork({
    required this.nftData,
    required this.layoutType,
    super.key,
  });

  final NftData nftData;
  final NftLayoutType layoutType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(
          size: 12.0.s,
          imageWidget: NetworkIconWidget(
            size: 12.0.s,
            imageUrl: nftData.network.image,
          ),
        ),
        SizedBox(width: 5.0.s),
        Text(
          nftData.network.displayName,
          style: context.theme.appTextThemes.caption3
              .copyWith(color: context.theme.appColors.quaternaryText),
        ),
      ],
    );
  }
}
