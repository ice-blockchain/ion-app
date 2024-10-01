// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/generated/assets.gen.dart';

class NftItem extends StatelessWidget {
  const NftItem({
    required this.nftData,
    this.backgroundColor,
    super.key,
  });

  final NftData nftData;
  final Color? backgroundColor;

  static double get imageWidth => 54.0.s;
  static double get imageHeight => 54.0.s;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(nftData.collectionName),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('#${nftData.rank}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5.0.s),
                child: Assets.images.wallet.walletEth.icon(size: 12.0.s),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4.0.s),
                child: Text(
                  '${nftData.price} ${nftData.currency}',
                  style: context.theme.appTextThemes.caption2.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? context.theme.appColors.tertararyBackground,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16.0.s),
        child: CachedNetworkImage(
          imageUrl: nftData.iconUrl,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
