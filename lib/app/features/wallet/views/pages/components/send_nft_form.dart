import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/slider/app_slider.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/components/arrival_time/arrival_time.dart';
import 'package:ice/app/features/wallet/components/network_fee/network_fee.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/contact_input_switcher.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/components/nft_name/nft_name.dart';
import 'package:ice/app/features/wallet/views/pages/nft_details/components/nft_picture/nft_picture.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SendNftForm extends HookConsumerWidget {
  const SendNftForm({super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContactId = useState<String?>(null);

    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendAssetFormControllerProvider(type: CryptoAssetType.nft));
    final selectedNft = formController.selectedNft;

    return SheetContent(
      backgroundColor: colors.secondaryBackground,
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: NavigationAppBar.screen(
                  title: Text(locale.send_nft_title),
                  actions: const [
                    NavigationCloseButton(),
                  ],
                ),
              ),
              if (selectedNft != null)
                ScreenSideOffset.small(
                  child: Column(
                    children: [
                      NftPicture(imageUrl: selectedNft.iconUrl),
                      SizedBox(height: 16.0.s),
                      NftName(
                        name: selectedNft.collectionName,
                        rank: selectedNft.rank,
                        price: selectedNft.price,
                        networkSymbol: selectedNft.currency,
                        networkSymbolIcon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                      ),
                      SizedBox(height: 16.0.s),
                      ContactInputSwitcher(
                        contactId: selectedContactId.value,
                        onContactSelected: (String? id) => selectedContactId.value = id,
                      ),
                      SizedBox(height: 17.0.s),
                      const ArrivalTime(),
                      SizedBox(height: 12.0.s),
                      AppSlider(
                        initialValue: formController.arrivalTime.toDouble(),
                        onChanged: (double value) {
                          ref
                              .read(sendAssetFormControllerProvider(type: CryptoAssetType.nft)
                                  .notifier)
                              .updateArrivalTime(value.toInt());
                        },
                      ),
                      SizedBox(height: 8.0.s),
                      const NetworkFee(),
                      SizedBox(height: 45.0.s),
                      Button(
                        label: Text(
                          locale.button_continue,
                        ),
                        mainAxisSize: MainAxisSize.max,
                        trailingIcon: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            colors.primaryBackground,
                            BlendMode.srcIn,
                          ),
                          child: Assets.images.icons.iconButtonNext.icon(),
                        ),
                        onPressed: () {
                          SendNftConfirmRoute().push<void>(context);
                        },
                      ),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              ScreenBottomOffset(),
            ],
          ),
        ),
      ),
    );
  }
}
