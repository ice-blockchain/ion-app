import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/components/title_value_block/title_value_block.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/send_nft/views/pages/nft_details/components/nft_description/nft_description.dart';
import 'package:ice/app/features/send_nft/views/pages/nft_details/components/nft_name/nft_name.dart';
import 'package:ice/app/features/send_nft/views/pages/nft_details/components/nft_picture/nft_picture.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class NftDetailsPage extends IcePage {
  const NftDetailsPage({
    required this.payload,
    super.key,
  });

  final NftData payload;

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    return SheetContentScaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      appBar: NavigationAppBar.screen(
        title: 'Send NFT',
        showBackButton: false,
        actions: <Widget>[
          IconButton(
            icon: Assets.images.icons.iconSheetClose.icon(
              size: NavigationAppBar.actionButtonSide,
              color: context.theme.appColors.primaryText,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: ScreenSideOffset.small(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.0.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NftPicture(imageUrl: payload.iconUrl),
              NftName(
                name: payload.collectionName,
                rank: payload.rank,
                price: payload.price,
                networkSymbol: payload.currency,
                networkSymbolIcon:
                    Assets.images.wallet.walletEth.icon(size: 16.0.s),
              ),
              NftDescription(description: payload.description),
              TitleValueBlock(
                title: context.i18n.send_nft_token_id,
                value: payload.identifier.toString(),
              ),
              TitleValueBlock(
                title: context.i18n.send_nft_token_network,
                value: payload.network.toString(),
              ),
              TitleValueBlock(
                title: context.i18n.send_nft_token_standard,
                value: payload.tokenStandard.toString(),
              ),
              TitleValueBlock(
                title: context.i18n.send_nft_token_contract_address,
                value: payload.contractAddress.toString(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.0.s, bottom: 16.0.s),
                child: Button(
                  mainAxisSize: MainAxisSize.max,
                  minimumSize: Size(56.0.s, 56.0.s),
                  leadingIcon: Assets.images.icons.iconButtonSend
                      .icon(color: context.theme.appColors.onPrimaryAccent),
                  label: Text(
                    context.i18n.feed_send,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
