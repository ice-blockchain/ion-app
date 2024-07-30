import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/read_more_text/read_more_text.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/components/nft_name/nft_name.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/components/nft_picture/nft_picture.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class NftDetailsPage extends ConsumerWidget {
  const NftDetailsPage({super.key, required this.nft});

  final NftData nft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(SendAssetFormControllerProvider(type: CryptoAssetType.nft));

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    NftPicture(imageUrl: nft.iconUrl),
                    SizedBox(height: 15.0.s),
                    NftName(
                      name: nft.collectionName,
                      rank: nft.rank,
                      price: nft.price,
                      networkSymbol: nft.currency,
                      networkSymbolIcon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 12.0.s),
                    RoundedCard(
                      child: ReadMoreText(
                        nft.description,
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_id),
                      value: nft.identifier.toString(),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(context.i18n.send_nft_token_network),
                      value: nft.network,
                      icon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_standard),
                      value: nft.tokenStandard,
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_contract_address),
                      value: nft.contractAddress,
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
                        ref
                            .read(
                                sendAssetFormControllerProvider(type: CryptoAssetType.nft).notifier)
                            .selectNft(nft);
                        NftSendFormRoute().push<void>(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}
