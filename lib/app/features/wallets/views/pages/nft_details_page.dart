// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/read_more_text/read_more_text.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/nft_name.dart';
import 'package:ion/app/features/wallets/views/components/nft_picture.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class NftDetailsPage extends ConsumerWidget {
  const NftDetailsPage({required this.tokenId, super.key});

  final String tokenId;

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
                    const NftPicture(imageUrl: 'nft.iconUrl'),
                    SizedBox(height: 15.0.s),
                    const NftName(
                      rank: 'nft.rank'.length,
                      name: 'nft.collectionName',
                    ),
                    SizedBox(height: 12.0.s),
                    RoundedCard.filled(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.i18n.common_desc,
                            style: context.theme.appTextThemes.caption3.copyWith(
                              color: context.theme.appColors.tertararyText,
                            ),
                          ),
                          SizedBox(height: 4.0.s),
                          const ReadMoreText(
                            'nft.description',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(context.i18n.send_nft_token_network),
                      value: 'nft.network.displayName',
                      icon: Assets.svg.networks.walletEth.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_standard),
                      value: 'nft.tokenStandard',
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.text(
                      title: Text(context.i18n.send_nft_token_contract_address),
                      value: 'nft.contractAddress',
                    ),
                    SizedBox(height: 12.0.s),
                    Button(
                      mainAxisSize: MainAxisSize.max,
                      minimumSize: Size(56.0.s, 56.0.s),
                      leadingIcon: Assets.svg.iconButtonSend
                          .icon(color: context.theme.appColors.onPrimaryAccent),
                      label: Text(
                        context.i18n.feed_send,
                      ),
                      onPressed: () {
                        // TODO
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
