import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/read_more_text/read_more_text.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/providers/send_nft_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/components/nft_name/nft_name.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/components/nft_picture/nft_picture.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class NftDetailsPage extends ConsumerWidget {
  const NftDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payload = ref.watch(sendNftFormControllerProvider);
    final selectedNft = payload.selectedNft;

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
                    NftPicture(imageUrl: selectedNft.iconUrl),
                    SizedBox(height: 15.0.s),
                    NftName(
                      name: selectedNft.collectionName,
                      rank: selectedNft.rank,
                      price: selectedNft.price,
                      networkSymbol: selectedNft.currency,
                      networkSymbolIcon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 12.0.s),
                    RoundedCard(
                      child: ReadMoreText(
                        selectedNft.description,
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_id),
                      value: selectedNft.identifier.toString(),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(context.i18n.send_nft_token_network),
                      value: selectedNft.network,
                      icon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_standard),
                      value: selectedNft.tokenStandard,
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_contract_address),
                      value: selectedNft.contractAddress,
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
