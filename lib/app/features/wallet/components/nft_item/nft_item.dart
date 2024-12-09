// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/nft_data.c.dart';

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
                padding: EdgeInsets.only(right: 4.0.s),
                child: Text(
                  ' ${nftData.currency}',
                  style: context.theme.appTextThemes.caption2.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor:
          backgroundColor ?? context.theme.appColors.tertararyBackground,
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
