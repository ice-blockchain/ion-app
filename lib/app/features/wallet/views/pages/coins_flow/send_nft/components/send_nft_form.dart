import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/slider/app_slider.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/send_nft/views/pages/nft_details/components/nft_name/nft_name.dart';
import 'package:ice/app/features/send_nft/views/pages/nft_details/components/nft_picture/nft_picture.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/arrival_time/arrival_time.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/contact_input_switcher.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/network_fee.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/providers/send_nft_form_provider.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SendNftForm extends HookConsumerWidget {
  const SendNftForm({required this.payload, super.key});

  final NftData payload;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContact = useState<ContactData?>(null);
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendNftFormControllerProvider);

    return SheetContent(
      backgroundColor: colors.secondaryBackground,
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: NavigationAppBar.screen(
                  title: locale.send_nft_title,
                  actions: const <Widget>[
                    NavigationCloseButton(),
                  ],
                ),
              ),
              ScreenSideOffset.small(
                child: Column(
                  children: <Widget>[
                    NftPicture(imageUrl: payload.iconUrl),
                    SizedBox(height: 16.0.s),
                    NftName(
                      name: payload.collectionName,
                      rank: payload.rank,
                      price: payload.price,
                      networkSymbol: payload.currency,
                      networkSymbolIcon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 16.0.s),
                    ContactInputSwitcher(
                      selectedContact: selectedContact.value,
                      onContactSelected: (ContactData? contact) => selectedContact.value = contact,
                    ),
                    SizedBox(height: 17.0.s),
                    const ArrivalTime(),
                    SizedBox(height: 12.0.s),
                    AppSlider(
                      initialValue: formController.arrivalTime.toDouble(),
                      onChanged: (double value) {
                        ref
                            .read(sendNftFormControllerProvider.notifier)
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
                        // NftSendFormConfirmationRoute().push<void>(context);
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
