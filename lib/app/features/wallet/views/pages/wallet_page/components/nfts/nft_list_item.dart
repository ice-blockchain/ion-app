import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/nft_layout_type.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_price.dart';

class NftListItem extends StatelessWidget {
  const NftListItem({
    required this.nftData,
    required this.onTap,
    super.key,
  });

  final NftData nftData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(nftData.collectionName),
      onTap: onTap,
      subtitle: Text('#${nftData.identifier}'),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: Avatar(
        size: 36.0.s,
        imageUrl: nftData.iconUrl,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(''),
          NftPrice(
            nftData: nftData,
            layoutType: NftLayoutType.list,
          ),
        ],
      ),
    );
  }
}
