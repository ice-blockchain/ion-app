import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/nft_item/nft_item.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/providers/send_nft_form_provider.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SendNftConfirmPage extends ConsumerWidget {
  const SendNftConfirmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final formData = ref.watch(sendNftFormControllerProvider);
    return SheetContent(
      body: Column(
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
                children: [
                  NftItem(nftData: formData.selectedNft),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_send_to),
                    secondary: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formData.address,
                        textAlign: TextAlign.right,
                        style: context.theme.appTextThemes.caption3.copyWith(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_title),
                    value: formData.wallet.name,
                    icon: Image.network(
                      formData.wallet.icon,
                      width: ScreenSideOffset.defaultSmallMargin,
                      height: ScreenSideOffset.defaultSmallMargin,
                    ),
                    secondary: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
                        textAlign: TextAlign.right,
                        style: context.theme.appTextThemes.caption3.copyWith(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.text(
                    title: Text(context.i18n.send_nft_confirm_asset),
                    value: formData.selectedNft.asset,
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(context.i18n.send_nft_confirm_network),
                    value: formData.selectedNft.network,
                    icon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_arrival_time),
                    value: '${formData.arrivalTime} '
                        '${locale.wallet_arrival_time_minutes}',
                    icon: Assets.images.icons.iconBlockTime.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_network_fee),
                    value: '1.00 USDT',
                    icon: Assets.images.icons.iconBlockCoins.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  Button(
                    mainAxisSize: MainAxisSize.max,
                    minimumSize: Size(56.0.s, 56.0.s),
                    label: Text(
                      context.i18n.button_confirm,
                    ),
                    onPressed: () {},
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
