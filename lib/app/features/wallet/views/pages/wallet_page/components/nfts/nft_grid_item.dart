import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/constants.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_price.dart';
import 'package:ice/app/utils/image.dart';

class NftGridItem extends HookConsumerWidget {
  const NftGridItem({
    super.key,
    required this.nftData,
  });

  final NftData nftData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BorderRadiusGeometry borderRadius = BorderRadius.circular(16.0.s);
    final double imageWidth = (MediaQuery.of(context).size.width -
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
        children: <Widget>[
          ClipRRect(
            borderRadius: borderRadius,
            child: CachedNetworkImage(
              imageUrl: getAdaptiveImageUrl(nftData.iconUrl, imageWidth * 2),
              width: imageWidth,
              height: imageWidth * 1.13,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            nftData.collectionName,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: <Widget>[
              Text(
                '#${nftData.identifier}',
                style: context.theme.appTextThemes.subtitle3.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
              ),
              const Spacer(),
              NftPrice(
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
