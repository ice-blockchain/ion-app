// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/nft_layout_type.dart';

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
        Avatar(size: 12.0.s, imageWidget: nftData.network.svgIconAsset.icon()),
        SizedBox(width: 5.0.s),
        Text(
          nftData.network.name,
          style: context.theme.appTextThemes.caption3
              .copyWith(color: context.theme.appColors.quaternaryText),
        ),
      ],
    );
  }
}
