import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/read_more_text/read_more_text.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/send_nft/views/pages/nft_details/components/nft_name/nft_name.dart';
import 'package:ice/app/features/send_nft/views/pages/nft_details/components/nft_picture/nft_picture.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class NftDetailsPage extends StatelessWidget {
  const NftDetailsPage({required this.payload, super.key});

  final NftData payload;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.send_nft_navigation_title),
            showBackButton: false,
            actions: const [NavigationCloseButton()],
          ),
          ScreenSideOffset.small(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10.0.s),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NftPicture(imageUrl: payload.iconUrl),
                  SizedBox(height: 15.0.s),
                  NftName(
                    name: payload.collectionName,
                    rank: payload.rank,
                    price: payload.price,
                    networkSymbol: payload.currency,
                    networkSymbolIcon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                  ),
                  SizedBox(height: 12.0.s),
                  RoundedCard(
                    child: ReadMoreText(
                      payload.description,
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.text(
                    title: Text(context.i18n.send_nft_token_id),
                    value: payload.identifier.toString(),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(context.i18n.send_nft_token_network),
                    value: payload.network,
                    icon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.text(
                    title: Text(context.i18n.send_nft_token_standard),
                    value: payload.tokenStandard,
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.text(
                    title: Text(context.i18n.send_nft_token_contract_address),
                    value: payload.contractAddress,
                  ),
                  SizedBox(height: 12.0.s),
                  Button(
                    mainAxisSize: MainAxisSize.max,
                    minimumSize: Size(56.0.s, 56.0.s),
                    leadingIcon: Assets.images.icons.iconButtonSend
                        .icon(color: context.theme.appColors.onPrimaryAccent),
                    label: Text(
                      context.i18n.feed_send,
                    ),
                    onPressed: () {
                      NftSendFormRoute($extra: payload).push<void>(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
