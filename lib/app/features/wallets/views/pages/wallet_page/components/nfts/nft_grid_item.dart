// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/nft_layout_type.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/constants.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_network.dart';

class NftGridItem extends StatelessWidget {
  const NftGridItem({
    required this.nftData,
    super.key,
  });

  final NftData nftData;

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry borderRadius = BorderRadius.circular(16.0.s);
    final imageWidth = (MediaQuery.sizeOf(context).width -
            NftConstants.cellPadding * 4 -
            NftConstants.gridSpacing -
            ScreenSideOffset.defaultSmallMargin * 2) /
        2;

    return Container(
      padding: EdgeInsets.all(NftConstants.cellPadding),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: context.theme.appColors.tertararyBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: CachedNetworkImage(
              imageUrl: nftData.tokenUri,
              width: imageWidth,
              height: imageWidth * 1.13,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            nftData.symbol,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Text(
                '#${nftData.tokenId}',
                style: context.theme.appTextThemes.subtitle3.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
              ),
              const Spacer(),
              NftNetwork(
                nftData: nftData,
                layoutType: NftLayoutType.grid,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
